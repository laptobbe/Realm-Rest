//
// Created by Tobias Sundstrand on 15-02-02.
//

#import <Realm-Rest/RestNotifier.h>
#import <Realm-Rest/RestOrchestrator.h>
#import <Realm-Rest/RestRequestQueue.h>
#import <Realm/RLMRealm.h>
#import <Realm+JSON/RLMObject+JSON.h>
#import "RLMObject+Rest.h"


@implementation RLMObject (Rest)

+ (NSString *)restSuccessNotification {
    return [NSString stringWithFormat:@"%@Success%@", NSStringFromClass(self), RestNotification];
}

+ (NSString *)restFailureNotification {
    return [NSString stringWithFormat:@"%@Failure%@", NSStringFromClass(self), RestNotification];
}

+ (NSString *)restWithRequestType:(RestRequestType)requestType parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers realm:(RLMRealm *)realm realmIdentifier:(NSString *)realmIdentifier {
    return [RestOrchestrator restForModelClass:self
                                   requestType:requestType
                                    parameters:parameters
                                       headers:headers
                                         realm:realm
                               realmIdentifier:realmIdentifier];
}

+ (NSString *)restInDefaultRealmWithRequestType:(RestRequestType)requestType parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers {
    return [self restWithRequestType:requestType
                          parameters:parameters
                             headers:headers
                               realm:[RLMRealm defaultRealm]
                     realmIdentifier:nil];
}

- (NSString *)restWithRequestType:(RestRequestType)requestType parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers realm:(RLMRealm *)realm realmIdentifier:(NSString *)realmIdentifier {
    NSMutableDictionary *newParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    newParameters[RestRequestParameterStyleJSON] = [self JSONDictionary];
    return [RestOrchestrator restForObject:(RLMObject <RestModelObjectProtocol> *) self
                               requestType:requestType
                                parameters:newParameters
                                   headers:headers
                                     realm:realm
                           realmIdentifier:realmIdentifier];
}

- (NSString *)restInDefaultRealmWithRequestType:(RestRequestType)requestType parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers {
    return [self restWithRequestType:requestType
                          parameters:parameters
                             headers:headers
                               realm:[RLMRealm defaultRealm]
                     realmIdentifier:nil];
}

@end