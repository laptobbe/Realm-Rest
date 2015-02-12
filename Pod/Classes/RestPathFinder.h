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

+ (NSString *)findPathForObject:(RLMObject <RestModelObjectProtocol> *)object forType:(RestRequestType)type action:(NSString *)action;

+ (NSString *)findPathForClass:(Class)class forType:(RestRequestType)type action:(NSString *)action;

+ (NSString *)findBaseURLForModelClass:(Class)pClass realm:(RLMRealm *)realm;

+ (NSString *)httpMethodFromRequestType:(RestRequestType)type;
@end