//
// Created by Tobias Sundstrand on 15-01-26.
// Copyright (c) 2015 Tobias Sundstrand. All rights reserved.
//

#import "Mouse.h"


@implementation Mouse

+ (NSString *)restPathForRequestType:(RestRequestType)requestType action:(NSString *)action {
    switch (requestType) {
        case RestRequestTypeGet:
            return @"rest/mouses";
        case RestRequestTypePost:
            return @"rest/mouses/create";
        case RestRequestTypePut:
            return @"rest/mouses/updates";
        case RestRequestTypeDelete:
            return @"rest/mouses/deletes";
    }
    return nil;
}

- (NSString *)restPathForRequestType:(RestRequestType)requestType action:(NSString *)action {
    switch (requestType) {
        case RestRequestTypeGet:
            return [NSString stringWithFormat:@"rest/mouse/%@", self.name];
        case RestRequestTypePost:
            return [NSString stringWithFormat:@"rest/mouse/%@/create", self.name];
        case RestRequestTypePut:
            return [NSString stringWithFormat:@"rest/mouse/%@/update", self.name];
        case RestRequestTypeDelete:
            return [NSString stringWithFormat:@"rest/mouse/%@/remove", self.name];
    }
    return nil;
}

+ (NSString *)primaryKey {
    return @"name";
}

+ (NSString *)baseURL {
    return @"http://custom.example.com";
}

+ (BOOL)shouldAbandonFailedRequest:(NSURLRequest *)request
                          response:(NSHTTPURLResponse *)response
                             error:(NSError *)error
                          userInfo:(NSDictionary *)userInfo {
    return YES;
}
@end