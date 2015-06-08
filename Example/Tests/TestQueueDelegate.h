//
// Created by Tobias Sundstrand on 15-01-30.
// Copyright (c) 2015 Tobias Sundstrand. All rights reserved.
//

#import <Realm-Rest/Realm-Rest.h>

typedef BOOL (^TestRestFailureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *userInfo);

typedef void (^TestRestSuccessBlock)(NSURLRequest *request, id responseObject, NSDictionary *userInfo);

@interface TestQueueDelegate : NSObject <RestRequestQueueDelegate>

@property (nonatomic, copy) TestRestSuccessBlock successBlock;
@property (nonatomic, copy) TestRestFailureBlock shouldAbandonFailedRequestBlock;

@end
