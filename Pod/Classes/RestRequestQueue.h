//
// Created by Tobias Sundstrand on 15-01-29.
//

#import <Foundation/Foundation.h>
#import <Realm-Rest/RestRequestBuilder.h>
#import <Realm-Rest/RestRequestQueue.h>

typedef NS_ENUM(NSInteger , RestRequestQueuePeristance) {
    RestRequestQueuePeristanceDatabase,
    RestRequestQueuePeristanceInMemory
};

/**
* Return YES to abandon the request
*/
typedef BOOL (^RestFailureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *userInfo);
typedef void (^RestSuccessBlock)(NSURLRequest *request, id responseObject, NSDictionary *userInfo);


@interface RestRequestQueue : NSObject

/**
* Set all properties before first request is enqueued. Default is RestRequestQueuePeristanceDatabase.
*/
@property (nonatomic, copy) RestFailureBlock shouldAbandonFailedRequestBlock;
@property (nonatomic, copy) RestSuccessBlock restSuccessBlock;

+ (instancetype)sharedInstance;

- (void)activateQueueWithPersistance:(RestRequestQueuePeristance)persistance;

/**
* @param userInfo Needs to be JSON encodable (String key and basic types as values)
*/
- (void)enqueueRequestWithBaseURL:(NSString *)baseURL
                             path:(NSString *)path
                           method:(NSString *)method
                       parameters:(NSDictionary *)params
                   parameterStyle:(RestRequestBuilderParameterStyle)paramStyle
                          headers:(NSDictionary *)headers
                         userInfo:(NSDictionary *)userInfo;

- (void)deactivateQueue;

@end