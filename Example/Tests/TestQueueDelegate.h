//
// Created by Tobias Sundstrand on 15-01-30.
// Copyright (c) 2015 Tobias Sundstrand. All rights reserved.
//


typedef BOOL (^RestFailureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *userInfo);

typedef void (^RestSuccessBlock)(NSURLRequest *request, id responseObject, NSDictionary *userInfo);

@interface TestQueueDelegate : NSObject <RestRequestQueueDelegate>

@property (nonatomic, copy) RestSuccessBlock successBlock;
@property (nonatomic, copy) RestFailureBlock shouldAbandonFailedRequestBlock;

@end
