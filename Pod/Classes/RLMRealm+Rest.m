//
// Created by Tobias Sundstrand on 15-01-30.
//

#import <objc/runtime.h>
#import "RLMRealm+Rest.h"


@implementation RLMRealm (Rest)
@dynamic baseURL;

- (NSString *)baseURL {
    return self.baseURLs[self.path];
}

- (void)setBaseURL:(NSString *)baseURL {
    self.baseURLs[self.path] = baseURL;
}

- (NSMutableDictionary *)baseURLs {
    static NSMutableDictionary *urls;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        urls = [NSMutableDictionary dictionary];
    });
    return urls;
}

@end