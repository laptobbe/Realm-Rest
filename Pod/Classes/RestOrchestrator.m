//
// Created by Tobias Sundstrand on 15-01-30.
//

#import <Realm/RLMObject.h>
#import <Realm-Rest/RestPathFinder.h>
#import <Realm-Rest/RestRequestBuilder.h>
#import <Realm-Rest/RestRequestQueue.h>
#import <Realm/RLMRealm.h>
#import <Realm+JSON/RLMObject+JSON.h>
#import "RestOrchestrator.h"

@interface RestOrchestrator () <RestRequestQueueDelegate>

@property (nonatomic, strong) NSMutableDictionary *requests;

@end

@implementation RestOrchestrator

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static RestOrchestrator *restOrchestrator;
    dispatch_once(&once, ^{
        restOrchestrator = [RestOrchestrator new];
        restOrchestrator.requests = [NSMutableDictionary dictionary];
    });
    return restOrchestrator;
}

+ (void)restForObject:(RLMObject <RestModelObjectProtocol> *)object
          requestType:(RestRequestType)requestType
           paramStyle:(RestRequestBuilderParameterStyle)parameterStyle
           parameters:(NSDictionary *)parameters
              headers:(NSDictionary *)headers
                queue:(RestRequestQueue *)queue
                realm:(RLMRealm *)realm
      realmIdentifier:(NSString *)realmIdentifier {

    [[self sharedInstance] restForObject:object
                             requestType:requestType
                              paramStyle:parameterStyle
                              parameters:parameters
                                 headers:headers
                                   queue:queue
                                   realm:realm
                         realmIdentifier:realmIdentifier];

}

- (void)restForObject:(RLMObject <RestModelObjectProtocol> *)object
          requestType:(RestRequestType)requestType
           paramStyle:(RestRequestBuilderParameterStyle)parameterStyle
           parameters:(NSDictionary *)parameters
              headers:(NSDictionary *)headers
                queue:(RestRequestQueue *)queue
                realm:(RLMRealm *)realm
      realmIdentifier:(NSString *)identifier{

    queue.delegate = self;

    NSString *baseURL = [RestPathFinder findBaseURLForModelClass:object.class realm:realm];
    NSString *path = [RestPathFinder findPathForObject:object forType:requestType];
    NSString *method = [RestPathFinder httpMethodFromRequestType:requestType];

    [queue enqueueRequestWithBaseURL:baseURL
                                path:path
                              method:method
                          parameters:parameters
                      parameterStyle:parameterStyle
                             headers:headers
                            userInfo:@{
                                    @"class": NSStringFromClass(object.class),
                                    @"realmType" : identifier ? @(RestRequestQueuePeristanceInMemory) : @(RestRequestQueuePeristanceDatabase),
                                    @"realm" : identifier ?: realm.path
                            }];
}

- (BOOL)             queue:(RestRequestQueue *)queue
shouldAbandonFailedRequest:(NSURLRequest *)request
                  response:(NSHTTPURLResponse *)response
                     error:(NSError *)error
                  userInfo:(NSDictionary *)userInfo {
    return NO;
}

- (void)    queue:(RestRequestQueue *)queue
requestDidSucceed:(NSURLRequest *)request
   responseObject:(id)responseObject
         userInfo:(NSDictionary *)userInfo {
    if (!responseObject) {
        return;
    }

    RLMRealm *realm = [self realmFromUserInfo:userInfo];
    Class modelClass = [self modelClassFromUserInfo:userInfo];

    if([responseObject isKindOfClass:[NSArray class]]) {
        [modelClass createOrUpdateInRealm:realm withJSONArray:responseObject];
    } else if([responseObject isKindOfClass:[NSDictionary class]]) {
        [modelClass createOrUpdateInRealm:realm withJSONDictionary:responseObject];
    }
}

- (Class)modelClassFromUserInfo:(NSDictionary *)dictionary {
    return NSClassFromString(dictionary[@"class"]);
}

- (RLMRealm *)realmFromUserInfo:(NSDictionary *)dictionary {
    if([dictionary[@"realmType"] integerValue] == RestRequestQueuePeristanceDatabase){
        return [RLMRealm realmWithPath:dictionary[@"realm"]];
    }else {
        return [RLMRealm inMemoryRealmWithIdentifier:dictionary[@"realm"]];
    }
}


@end