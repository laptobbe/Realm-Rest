//
// Created by Tobias Sundstrand on 15-01-30.
//

#import <objc/runtime.h>
#import "RLMRealm+Rest.h"


@implementation RLMRealm (Rest)

- (NSString *)baseURL {
    return objc_getAssociatedObject(self, @selector(baseURL));
}

- (void)setBaseURL:(NSString *)baseURL {
    objc_setAssociatedObject(self, @selector(baseURL), baseURL, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end