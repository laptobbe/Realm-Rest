//
// Created by Tobias Sundstrand on 15-01-29.
//

#import <Foundation/Foundation.h>
#import <Realm-Rest/RestRequestBuilder.h>
#import <Realm-Rest/RestRequestQueue.h>
#import "RestRequestQueue.h"

typedef NS_ENUM(NSInteger , RestRequestQueuePeristance) {
    RestRequestQueuePeristanceDatabase,
    RestRequestQueuePeristanceInMemory
};


@class RestRequestQueue;

@protocol RestRequestQueueDelegate

@required
- (BOOL)queue:(RestRequestQueue *)queue shouldAbandonFailedRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *)response error:(NSError *)error userInfo:(NSDictionary *)userInfo;
- (void)queue:(RestRequestQueue *)queue requestDidSucceed:(NSURLRequest *)request responseObject:(id)responseObject userInfo:(NSDictionary *)userInfo;

@end

@interface RestRequestQueue : NSObject

/**
* Set all properties before first request is enqueued. Default is RestRequestQueuePeristanceDatabase.
*/
@property (nonatomic, assign) NSObject<RestRequestQueueDelegate> *delegate;

@property (nonatomic, readonly) NSUInteger count;

- (instancetype)initWitPersistance:(RestRequestQueuePeristance)persistance
                          delegate:(NSObject <RestRequestQueueDelegate> *)delegate;

/**
* @param userInfo Needs to be JSON encodable (String key and basic types as values)
* @params Use the keys: RestRequestParameterStyleURL, RestRequestParameterStyleJSON, RestRequestParameterStyleForm
* with dictionary as values. JSON and Form are mutually exclusive. JSON overrides Form.
*/
- (void)enqueueRequestWithBaseURL:(NSString *)baseURL
                             path:(NSString *)path
                           method:(NSString *)method
                       parameters:(NSDictionary *)params
                          headers:(NSDictionary *)headers
                         userInfo:(NSDictionary *)userInfo;

- (void)deactivateQueue;

@end