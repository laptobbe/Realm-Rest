//
// Created by Tobias Sundstrand on 15-02-02.
//

#import <Foundation/Foundation.h>
#import <Realm/RLMObject.h>
#import <Realm-Rest/RestPathFinder.h>

@interface RLMObject (Rest)

+ (NSString *)restSuccessNotification;

+ (NSString *)restFailureNotification;

+ (void)restWithRequestType:(RestRequestType)requestType
                 parameters:(NSDictionary *)parameters
                    headers:(NSDictionary *)headers
                      realm:(RLMRealm *)realm
            realmIdentifier:(NSString *)realmIdentifier;

+ (void)restInDefaultRealmWithRequestType:(RestRequestType)requestType
                               parameters:(NSDictionary *)parameters
                                  headers:(NSDictionary *)headers;

- (void)restInDefaultRealmWithRequestType:(RestRequestType)requestType
                               parameters:(NSDictionary *)parameters
                                  headers:(NSDictionary *)headers;

- (void)restWithRequestType:(RestRequestType)requestType
                 parameters:(NSDictionary *)parameters
                    headers:(NSDictionary *)headers
                      realm:(RLMRealm *)realm
            realmIdentifier:(NSString *)realmIdentifier;
@end