//
// Created by Tobias Sundstrand on 15-01-30.
//

#import <Realm/RLMObject.h>
#import <Realm-Rest/RestPathFinder.h>
#import <Realm-Rest/RestRequestBuilder.h>
#import <Realm-Rest/RestRequestQueue.h>
#import <Realm/RLMRealm.h>
#import "RestOrchestrator.h"
#import "RestRequestBuilder.h"

@interface RestOrchestrator ()

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

    //queue.delegate = self;

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
                                    @"id": [object valueForKey:[[object class] primaryKey]],
                                    @"realmType" : identifier ? @"memory" : @"disk",
                                    @"realm" : identifier ?: realm.path
                            }];


}

@end