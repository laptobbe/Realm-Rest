//
// Created by Tobias Sundstrand on 15-01-30.
//

#import <Realm/RLMObject.h>
#import <Realm-Rest/RestPathFinder.h>
#import <Realm-Rest/RestRequestBuilder.h>
#import <Realm-Rest/RestRequestQueue.h>
#import <Realm-Rest/RestNotifier.h>
#import <Realm/RLMRealm.h>
#import <Realm+JSON/RLMObject+JSON.h>
#import <OCMock/OCMArg.h>
#import <Functional.m/NSArray+F.h>
#import "RestOrchestrator.h"
#import "RestModelObjectProtocol.h"


@interface RestOrchestrator () <RestRequestQueueDelegate>

@property (nonatomic, strong) RestRequestQueue *queue;

@end

@implementation RestOrchestrator

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static RestOrchestrator *restOrchestrator;
    dispatch_once(&once, ^{
        restOrchestrator = [RestOrchestrator new];
    });
    return restOrchestrator;
}

- (void)initiateWithPersistance:(RestRequestQueuePeristance)persistance {
    self.queue = [[RestRequestQueue alloc] initWitPersistance:persistance
                                                     delegate:self];
}

+ (NSString *)restForModelClass:(Class)modelClass
              requestType:(RestRequestType)requestType
               parameters:(NSDictionary *)parameters
                  headers:(NSDictionary *)headers
                    realm:(RLMRealm *)realm
          realmIdentifier:(NSString *)realmIdentifier {

    return [[self sharedInstance] restForModelClass:modelClass
                                 requestType:requestType
                                  parameters:parameters
                                     headers:headers
                                       realm:realm
                             realmIdentifier:realmIdentifier];
}

- (NSString *)restForModelClass:(Class)modelClass
              requestType:(RestRequestType)requestType
               parameters:(NSDictionary *)parameters
                  headers:(NSDictionary *)headers
                    realm:(RLMRealm *)realm
          realmIdentifier:(NSString *)realmIdentifier {

    NSString *requestId = [[NSUUID UUID] UUIDString];
    NSString *baseURL = [RestPathFinder findBaseURLForModelClass:modelClass realm:realm];
    NSString *path = [RestPathFinder findPathForClass:modelClass forType:requestType];
    NSString *method = [RestPathFinder httpMethodFromRequestType:requestType];

    [self.queue enqueueRequestWithBaseURL:baseURL path:path method:method parameters:parameters headers:headers userInfo:@{
            RequestIdKey : requestId,
            ClassKey : NSStringFromClass(modelClass),
            RealmTypeKey : realmIdentifier ? @(RestRequestQueuePeristanceInMemory) : @(RestRequestQueuePeristanceDatabase),
            RealmKey : realmIdentifier ?: realm.path.lastPathComponent
    }];
    return requestId;
}

+ (NSString *)restForObject:(RLMObject <RestModelObjectProtocol> *)object
          requestType:(RestRequestType)requestType
           parameters:(NSDictionary *)parameters
              headers:(NSDictionary *)headers
                realm:(RLMRealm *)realm
      realmIdentifier:(NSString *)realmIdentifier {

    return [[self sharedInstance] restForObject:object
                             requestType:requestType
                              parameters:parameters
                                 headers:headers
                                   realm:realm
                         realmIdentifier:realmIdentifier];

}

- (NSString *)restForObject:(RLMObject <RestModelObjectProtocol> *)object
          requestType:(RestRequestType)requestType
           parameters:(NSDictionary *)parameters
              headers:(NSDictionary *)headers
                realm:(RLMRealm *)realm
      realmIdentifier:(NSString *)realmIdentifier {

    NSString *requestId = [[NSUUID UUID] UUIDString];
    NSString *baseURL = [RestPathFinder findBaseURLForModelClass:object.class realm:realm];
    NSString *path = [RestPathFinder findPathForObject:object forType:requestType];
    NSString *method = [RestPathFinder httpMethodFromRequestType:requestType];

    [self.queue enqueueRequestWithBaseURL:baseURL path:path method:method parameters:parameters headers:headers userInfo:@{
            RequestIdKey : requestId,
            ClassKey : NSStringFromClass(object.class),
            BaseUrlKey : baseURL,
            PathUrlKey : path,
            MethodKey : method,
            RealmTypeKey : realmIdentifier ? @(RestRequestQueuePeristanceInMemory) : @(RestRequestQueuePeristanceDatabase),
            RealmKey : realmIdentifier ?: realm.path.lastPathComponent
    }];
    return requestId;
}

- (BOOL)             queue:(RestRequestQueue *)queue
shouldAbandonFailedRequest:(NSURLRequest *)request
                  response:(NSHTTPURLResponse *)response
                     error:(NSError *)error
                  userInfo:(NSDictionary *)userInfo {

    NSMutableDictionary *notification = [NSMutableDictionary dictionary];
    [notification addEntriesFromDictionary:userInfo];
    notification[NSUnderlyingErrorKey] = error;
    notification[ResponseKey] = response;
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

    @try {

        id object;
        [realm beginWriteTransaction];
        if([responseObject isKindOfClass:[NSArray class]]) {
            object = [modelClass createOrUpdateInRealm:realm withJSONArray:responseObject];
        } else if([responseObject isKindOfClass:[NSDictionary class]]) {
            object = [modelClass createOrUpdateInRealm:realm withJSONDictionary:responseObject];
        }

        id primaryKeyValuesForObject = [self primaryKeyValuesForObject:object];
        if(primaryKeyValuesForObject) {
            notification[PrimaryKeyValueKey] = primaryKeyValuesForObject;
        }

        [RestNotifier notifySuccessWithUserInfo:notification];
    }
    @catch (NSException *exception) {
        notification[NSUnderlyingErrorKey] = exception;
        notification[ResponseKey] = responseObject;
        [RestNotifier notifyFailureWithUserInfo:notification];
    } @finally {
        [realm commitWriteTransaction];
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