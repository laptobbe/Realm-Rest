//
// Created by Tobias Sundstrand on 15-01-30.
// Copyright (c) 2015 Tobias Sundstrand. All rights reserved.
//

#import <Realm-Rest/RestRequestQueue.h>
#include "TestQueueDelegate.h"



@implementation TestQueueDelegate

- (BOOL)             queue:(RestRequestQueue *)queue
shouldAbandonFailedRequest:(NSURLRequest *)request
                  response:(NSHTTPURLResponse *)response
                     error:(NSError *)error
                  userInfo:(NSDictionary *)userInfo {
    return self.shouldAbandonFailedRequestBlock(request, response, error, userInfo);
}

- (void)    queue:(RestRequestQueue *)queue
requestDidSucceed:(NSURLRequest *)request
   responseObject:(id)responseObject
         userInfo:(NSDictionary *)userInfo {
    self.successBlock(request, responseObject, userInfo);
}


@end