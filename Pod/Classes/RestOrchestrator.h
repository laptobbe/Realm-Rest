//
// Created by Tobias Sundstrand on 15-01-30.
//

#import <Foundation/Foundation.h>
#import <Realm-Rest/RestRequestBuilder.h>
#import <Realm-Rest/RestPathFinder.h>
#import <Realm-Rest/RestRequestQueue.h>
#import "RestRequestBuilder.h"
#import "RestPathFinder.h"

@protocol RestModelObjectProtocol;
@class RLMObject;
@class RestRequestQueue;
@class RLMRealm;

@interface RestOrchestrator : NSObject

+ (instancetype)sharedInstance;

- (void)initiateWithPersistance:(RestRequestQueuePeristance)persistance;

- (void)restForModelClass:(Class)modelClass
              requestType:(RestRequestType)requestType
               parameters:(NSDictionary *)parameters
                  headers:(NSDictionary *)headers
                    realm:(RLMRealm *)realm
          realmIdentifier:(NSString *)realmIdentifier;

- (void)restForObject:(RLMObject <RestModelObjectProtocol> *)object
          requestType:(RestRequestType)requestType
           parameters:(NSDictionary *)parameters
              headers:(NSDictionary *)headers
                realm:(RLMRealm *)realm
      realmIdentifier:(NSString *)realmIdentifier;

+ (void)restForModelClass:(Class)modelClass
              requestType:(RestRequestType)requestType
               parameters:(NSDictionary *)parameters
                  headers:(NSDictionary *)headers
                    realm:(RLMRealm *)realm
          realmIdentifier:(NSString *)realmIdentifier;

+ (void)restForObject:(RLMObject <RestModelObjectProtocol> *)object
          requestType:(RestRequestType)requestType
           parameters:(NSDictionary *)parameters
              headers:(NSDictionary *)headers
                realm:(RLMRealm *)realm
      realmIdentifier:(NSString *)realmIdentifier;

@end