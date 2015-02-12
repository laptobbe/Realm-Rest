//
// Created by Tobias Sundstrand on 15-02-02.
//

#import <Foundation/Foundation.h>
#import <Realm/RLMObject.h>
#import <Realm-Rest/RestPathFinder.h>
#import <Realm-Rest/RestConstants.h>

typedef void (^RestSuccessBlock)(id primaryKey);
typedef void (^RestFailureBlock)(NSError *error, NSDictionary *userInfo);

@interface RLMObject (Rest)

+ (NSString *)restSuccessNotification;

+ (NSString *)restFailureNotification;

+ (NSString *)restWithRequestType:(RestRequestType)requestType
                       parameters:(NSDictionary *)parameters
                          headers:(NSDictionary *)headers
                            realm:(RLMRealm *)realm
                  realmIdentifier:(NSString *)realmIdentifier
                           action:(NSString *)action;

- (NSString *)restWithRequestType:(RestRequestType)requestType
                       parameters:(NSDictionary *)parameters
                          headers:(NSDictionary *)headers
                            realm:(RLMRealm *)realm
                  realmIdentifier:(NSString *)realmIdentifier
                           action:(NSString *)action;

+ (NSString *)restInDefaultRealmWithRequestType:(RestRequestType)requestType
                                     parameters:(NSDictionary *)parameters
                                        headers:(NSDictionary *)headers
                                         action:(NSString *)action;

- (NSString *)restInDefaultRealmWithRequestType:(RestRequestType)requestType
                                     parameters:(NSDictionary *)parameters
                                        headers:(NSDictionary *)headers
                                         action:(NSString *)action;

+ (NSString *)restWithRequestType:(RestRequestType)requestType
                       parameters:(NSDictionary *)parameters
                          headers:(NSDictionary *)headers
                            realm:(RLMRealm *)realm
                  realmIdentifier:(NSString *)realmIdentifier
                           action:(NSString *)action
                          success:(RestSuccessBlock)success
                          failure:(RestFailureBlock)failure;

- (NSString *)restWithRequestType:(RestRequestType)requestType
                       parameters:(NSDictionary *)parameters
                          headers:(NSDictionary *)headers
                            realm:(RLMRealm *)realm
                  realmIdentifier:(NSString *)realmIdentifier
                           action:(NSString *)action
                          success:(RestSuccessBlock)success
                          failure:(RestFailureBlock)failure;

+ (NSString *)restInDefaultRealmWithRequestType:(RestRequestType)requestType
                                     parameters:(NSDictionary *)parameters
                                        headers:(NSDictionary *)headers
                                         action:(NSString *)action
                                        success:(RestSuccessBlock)success
                                        failure:(RestFailureBlock)failure;

- (NSString *)restInDefaultRealmWithRequestType:(RestRequestType)requestType
                                     parameters:(NSDictionary *)parameters
                                        headers:(NSDictionary *)headers
                                         action:(NSString *)action
                                        success:(RestSuccessBlock)success
                                        failure:(RestFailureBlock)failure;
@end