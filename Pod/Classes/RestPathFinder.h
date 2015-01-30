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

typedef NS_ENUM(NSInteger , RestRequestType) {
    RestRequestTypeGet,
    RestRequestTypePost,
    RestRequestTypePut,
    RestRequestTypeDelete
};

@interface RestPathFinder : NSObject

+ (NSString *)findPathForObject:(RLMObject<RestModelObjectProtocol> *)object forType:(RestRequestType)type;

+ (NSString *)findPathForClass:(Class)class forType:(RestRequestType)type;

+ (NSString *)findBaseURLForModelClass:(Class)pClass realm:(RLMRealm *)realm;

+ (NSString *)httpMethodFromRequestType:(enum RestRequestType)type;
@end