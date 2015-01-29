//
// Created by Tobias Sundstrand on 15-01-29.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , RestRequestQueuePeristance) {
    RestRequestQueuePeristanceDatabase,
    RestRequestQueuePeristanceInMemory
};

@class RestRequestQueue;

@protocol RestRequestQueueDelegate

- (BOOL)requestQueue:(RestRequestQueue *)queue shouldAbbondonRequest:(NSURLRequest *)request withResponse:(NSURLResponse *)response;

@end

@interface RestRequestQueue : NSObject

@property (nonatomic, assign) id<RestRequestQueueDelegate> delegate;

/**
* Set before first request is enqueued. Default is RestRequestQueuePeristanceDatabase.
*/
@property (nonatomic, assign) RestRequestQueuePeristance persistance;

+ (instancetype)sharedInstance;

- (void)enqueueRequest:(NSURLRequest *)request;

- (void)emptyQueue;

@end