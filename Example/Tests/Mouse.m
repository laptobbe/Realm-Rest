//
// Created by Tobias Sundstrand on 15-01-26.
// Copyright (c) 2015 Tobias Sundstrand. All rights reserved.
//

#import "Mouse.h"
#import "RestPathFinder.h"


@implementation Mouse

+ (NSString *)restPathForRequestType:(RestRequestType)requestType action:(NSString *)action {
    switch (requestType) {
        case RestRequestTypeGet:
            if([action isEqualToString:@"chasing"]){
                return @"rest/mouses/chase";
            } else{
                return @"rest/mouses";
            }
        case RestRequestTypePost:
            if([action isEqualToString:@"chasing"]){
                return @"rest/mouses/create/chase";
            } else {
                return @"rest/mouses/create";
            }
        case RestRequestTypePut:
            if([action isEqualToString:@"chasing"]){
                return @"rest/mouses/updates/chase";
            }else {
                return @"rest/mouses/updates";
            }
        case RestRequestTypeDelete:
            if([action isEqualToString:@"chasing"]){
                return @"rest/mouses/deletes/chase";
            } else {
                return @"rest/mouses/deletes";
            }
    }
    return nil;
}

- (NSString *)restPathForRequestType:(RestRequestType)requestType action:(NSString *)action {
    switch (requestType) {
        case RestRequestTypeGet:
            if([action isEqualToString:@"chasing"]){
                return [NSString stringWithFormat:@"rest/mouse/%@/chase", self.name];
            } else {
                return [NSString stringWithFormat:@"rest/mouse/%@", self.name];
            }
        case RestRequestTypePost:
            if([action isEqualToString:@"chasing"]){
                return [NSString stringWithFormat:@"rest/mouse/%@/create/chase", self.name];
            } else {
                return [NSString stringWithFormat:@"rest/mouse/%@/create", self.name];
            }
        case RestRequestTypePut:
            if([action isEqualToString:@"chasing"]){
                return [NSString stringWithFormat:@"rest/mouse/%@/update/chase", self.name];
            } else {
                return [NSString stringWithFormat:@"rest/mouse/%@/update", self.name];
            }
        case RestRequestTypeDelete:
            if([action isEqualToString:@"chasing"]){
                return [NSString stringWithFormat:@"rest/mouse/%@/remove/chase", self.name];
            } else {
                return [NSString stringWithFormat:@"rest/mouse/%@/remove", self.name];
            }
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