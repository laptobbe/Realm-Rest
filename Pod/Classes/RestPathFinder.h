//
//  RestPathFinder.h
//  Pods
//
//  Created by Tobias Sundstrand on 2015-01-25.
//
//

#import <Foundation/Foundation.h>
#import <Realm-Rest/RestModelObjectProtocol.h>

@class RLMObject;
@class RLMRealm;

@interface RestPathFinder : NSObject

+ (NSString *)findPathForObject:(RLMObject <RestModelObjectProtocol> *)object forType:(RestRequestType)type userInfo:(NSDictionary *)userInfo;

+ (NSString *)findPathForClass:(Class)class forType:(RestRequestType)type userInfo:(NSDictionary *)userInfo;

+ (NSString *)findBaseURLForModelClass:(Class)pClass realm:(RLMRealm *)realm;

+ (NSString *)httpMethodFromRequestType:(RestRequestType)type;
@end