//
// Created by Tobias Sundstrand on 15-01-26.
//

#import <Foundation/Foundation.h>

@protocol RestModelObjectProtocol <NSObject>

@required
+ (NSString *)primaryKey;

@optional
+ (NSString *)restPathToResources;

@end