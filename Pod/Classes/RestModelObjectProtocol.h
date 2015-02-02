//
// Created by Tobias Sundstrand on 15-01-26.
//

#import <Foundation/Foundation.h>

@protocol RestModelObjectProtocol <NSObject>

@required
+ (NSString *)primaryKey;

@optional

+ (NSString *)restPathToResourceGET;
+ (NSString *)restPathToResourcePOST;
+ (NSString *)restPathToResourcePUT;
+ (NSString *)restPathToResourceDELETE;

- (NSString *)restPathToResourceGET;
- (NSString *)restPathToResourcePOST;
- (NSString *)restPathToResourcePUT;
- (NSString *)restPathToResourceDELETE;

+ (NSString *)baseURL;

+ (BOOL)shouldAbandonFailedRequest:(NSURLRequest *)request
                          response:(NSHTTPURLResponse *)response
                             error:(NSError *)error
                          userInfo:(NSDictionary *)userInfo;

@end