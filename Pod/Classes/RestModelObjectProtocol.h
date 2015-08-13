//
// Created by Tobias Sundstrand on 15-01-26.
//

#import <Foundation/Foundation.h>
#import <Realm-Rest/RestConstants.h>


@protocol RestModelObjectProtocol <NSObject>

@required
+ (NSString *)primaryKey;

@optional

+ (NSString *)restPathForRequestType:(RestRequestType)requestType userInfo:(NSDictionary *)userInfo;
- (NSString *)restPathForRequestType:(RestRequestType)requestType userInfo:(NSDictionary *)userInfo;

+ (NSString *)baseURL;

+ (BOOL)shouldAbandonFailedRequest:(NSURLRequest *)request
                          response:(NSHTTPURLResponse *)response
                             error:(NSError *)error
                          userInfo:(NSDictionary *)userInfo;

@end