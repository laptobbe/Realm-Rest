//
// Created by Tobias Sundstrand on 15-01-26.
// Copyright (c) 2015 Tobias Sundstrand. All rights reserved.
//

#import "Mouse.h"


@implementation Mouse

+ (NSString *)restPathToResourceGET {
    return @"rest/mouses";
}

+ (NSString *)restPathToResourcePOST {
    return @"rest/mouses/create";
}

+ (NSString *)restPathToResourcePUT {
    return @"rest/mouses/updates";
}

+ (NSString *)restPathToResourceDELETE {
    return @"rest/mouses/deletes";
}

- (NSString *)restPathToResourceGET {
    return [NSString stringWithFormat:@"rest/mouse/%@",self.name];
}

- (NSString *)restPathToResourcePOST {
    return [NSString stringWithFormat:@"rest/mouse/%@/create", self.name];
}

- (NSString *)restPathToResourcePUT {
    return [NSString stringWithFormat:@"rest/mouse/%@/update", self.name];
}

- (NSString *)restPathToResourceDELETE {
    return [NSString stringWithFormat:@"rest/mouse/%@/remove", self.name];
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