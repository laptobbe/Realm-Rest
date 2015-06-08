//
// Created by Tobias Sundstrand on 15-01-30.
//

#import "RestOrchestrator.h"
#import <Realm/RLMObject.h>
#import <Realm-Rest/RestNotifier.h>
#import <Realm/RLMRealm.h>
#import <Realm+JSON/RLMObject+JSON.h>
#import <Functional.m/NSArray+F.h>
#import <Realm-Rest/RestRequestQueue.h>

@interface RestOrchestrator () <RestRequestQueueDelegate>

@property (nonatomic, strong) RestRequestQueue *queue;

@end

@implementation RestOrchestrator

- (RestRequestQueuePeristance)peristance {
    return self.queue.persistance;
}

- (instancetype)initWithPersistance:(RestRequestQueuePeristance)persistance {
    self = [super init];
    if (self) {
        self.queue = [[RestRequestQueue alloc] initWitPersistance:persistance delegate:self];
    }
    return self;
}


- (void)restForModelClass:(Class)modelClass
              requestType:(RestRequestType)requestType
                requestId:(NSString *)requestId
               parameters:(NSDictionary *)parameters
                  headers:(NSDictionary *)headers
                    realm:(RLMRealm *)realm
          realmIdentifier:(NSString *)realmIdentifier
                   action:(NSString *)action {

    NSString *baseURL = [RestPathFinder findBaseURLForModelClass:modelClass realm:realm];
    NSString *path = [RestPathFinder findPathForClass:modelClass forType:requestType action:action];
    NSString *method = [RestPathFinder httpMethodFromRequestType:requestType];
    NSMutableDictionary *newHeaders = [[NSMutableDictionary alloc] initWithDictionary:headers];

    if (parameters[RestRequestParameterStyleJSON]) {
        newHeaders[RestRequestHeaderContentType] = @"application/json";
    }

    [self.queue enqueueRequestWithBaseURL:baseURL path:path method:method parameters:parameters headers:newHeaders userInfo:@{
            RequestIdKey : requestId,
            ClassKey : NSStringFromClass(modelClass),
            RealmTypeKey : realmIdentifier ? @(RestRequestQueuePeristanceInMemory) : @(RestRequestQueuePeristanceDatabase),
            RealmKey : realmIdentifier ?: realm.path.lastPathComponent,
            ActionKey : action ?: @"<none>"
    }];
}

- (void)restForObject:(RLMObject <RestModelObjectProtocol> *)object
          requestType:(RestRequestType)requestType
            requestId:(NSString *)requestId
           parameters:(NSDictionary *)parameters
              headers:(NSDictionary *)headers
                realm:(RLMRealm *)realm
      realmIdentifier:(NSString *)realmIdentifier
               action:(NSString *)action {

    NSString *baseURL = [RestPathFinder findBaseURLForModelClass:object.class realm:realm];
    NSString *path = [RestPathFinder findPathForObject:object forType:requestType action:action];
    NSString *method = [RestPathFinder httpMethodFromRequestType:requestType];
    NSMutableDictionary *newHeaders = [[NSMutableDictionary alloc] initWithDictionary:headers];

    if (parameters[RestRequestParameterStyleJSON]) {
        newHeaders[RestRequestHeaderContentType] = @"application/json";
    }

    [self.queue enqueueRequestWithBaseURL:baseURL path:path method:method parameters:parameters headers:newHeaders userInfo:@{
            RequestIdKey : requestId,
            ClassKey : NSStringFromClass(object.class),
            BaseUrlKey : baseURL,
            PathUrlKey : path,
            MethodKey : method,
            RealmTypeKey : realmIdentifier ? @(RestRequestQueuePeristanceInMemory) : @(RestRequestQueuePeristanceDatabase),
            RealmKey : realmIdentifier ?: realm.path.lastPathComponent,
            ActionKey : action ?: @"<none>"
    }];
}

- (BOOL)             queue:(RestRequestQueue *)queue
shouldAbandonFailedRequest:(NSURLRequest *)request
                  response:(NSHTTPURLResponse *)response
                     error:(NSError *)error
                  userInfo:(NSDictionary *)userInfo {

    NSMutableDictionary *notification = [NSMutableDictionary dictionary];
    [notification addEntriesFromDictionary:userInfo];

    if(error) {
        notification[NSUnderlyingErrorKey] = error;
    }

    if(response) {
        notification[ResponseKey] = response;
    }

    [RestNotifier notifyFailureWithUserInfo:notification];

    Class modelClass = [self modelClassFromUserInfo:userInfo];
    if([modelClass respondsToSelector:@selector(shouldAbandonFailedRequest:response:error:userInfo:)]){
        return [(Class<RestModelObjectProtocol>)modelClass shouldAbandonFailedRequest:request
                                                                             response:response
                                                                                error:error
                                                                             userInfo:userInfo];
    }
    return response.statusCode >= 400;
}

- (void)    queue:(RestRequestQueue *)queue
requestDidSucceed:(NSURLRequest *)request
   responseObject:(id)responseObject
         userInfo:(NSDictionary *)userInfo {
    if (!responseObject) {
        return;
    }

    NSMutableDictionary *notification = [NSMutableDictionary dictionary];
    RLMRealm *realm = [self realmFromUserInfo:userInfo];
    Class modelClass = [self modelClassFromUserInfo:userInfo];
    [notification addEntriesFromDictionary:userInfo];

    id object;

    BOOL success = NO;
    @try {
        [realm beginWriteTransaction];
        if([responseObject isKindOfClass:[NSArray class]]) {
            object = [modelClass createOrUpdateInRealm:realm withJSONArray:responseObject];
        } else if([responseObject isKindOfClass:[NSDictionary class]]) {
            object = [modelClass createOrUpdateInRealm:realm withJSONDictionary:responseObject];
        }
        [realm commitWriteTransaction];
        success = YES;
    } @catch (NSException *exception) {
        [realm cancelWriteTransaction];

        notification[NSUnderlyingErrorKey] = exception;

        if(responseObject) {
            notification[ResponseKey] = responseObject;
        }

        [RestNotifier notifyFailureWithUserInfo:notification];
    }

    if(success){
        id primaryKeyValuesForObject = [self primaryKeyValuesForObject:object];
        if(primaryKeyValuesForObject) {
            notification[PrimaryKeyValueKey] = primaryKeyValuesForObject;
        }

        [RestNotifier notifySuccessWithUserInfo:notification];
    }

}

- (id)primaryKeyValuesForObject:(id)object {
    if ([object isKindOfClass:[RLMObject class]]) {
        return [object valueForKey:[[object class] primaryKey]];
    }else if([object isKindOfClass:[NSArray class]]){
        return [object map:^id(id obj) {
            return [self primaryKeyValuesForObject:obj];
        }];
    }
    return nil;
}

- (Class)modelClassFromUserInfo:(NSDictionary *)dictionary {
    return NSClassFromString(dictionary[ClassKey]);
}

- (RLMRealm *)realmFromUserInfo:(NSDictionary *)dictionary {
    if([dictionary[RealmTypeKey] integerValue] == RestRequestQueuePeristanceDatabase){
        return [RLMRealm realmWithPath:[self pathWithName:dictionary[RealmKey]]];
    }else {
        return [RLMRealm inMemoryRealmWithIdentifier:dictionary[RealmKey]];
    }
}

- (NSString *)pathWithName:(NSString *)name {
    NSString *documentdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentdir stringByAppendingPathComponent:name];
    return path;

}


@end