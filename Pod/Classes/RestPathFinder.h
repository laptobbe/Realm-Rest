//
//  RestPathFinder.h
//  Pods
//
//  Created by Tobias Sundstrand on 2015-01-25.
//
//

#import <Foundation/Foundation.h>

@class RLMObject;

typedef NS_ENUM(NSInteger , RestRequestType) {
    RestRequestTypeGetAll,
    RestRequestTypeGet,
    RestRequestTypePost,
    RestRequestTypePut,
    RestRequestTypeDelete
};

@interface RestPathFinder : NSObject

+ (NSString *)findPathForObject:(RLMObject *)object forType:(RestRequestType)type;

@end