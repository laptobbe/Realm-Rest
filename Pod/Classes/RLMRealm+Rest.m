//
// Created by Tobias Sundstrand on 15-01-30.
//

#import <Realm-Rest/RestRequestQueue.h>
#import <Realm-Rest/RestOrchestrator.h>
#import "RLMRealm+Rest.h"


@implementation RLMRealm (Rest)

- (NSString *)baseURL {
    return self.baseURLs[self.path];
}

- (RestOrchestrator *)orchistrator {
    return self.orchistrators[self.path];
}

- (void)setBaseUrl:(NSString *)baseUrl queuePersistance:(RestRequestQueuePeristance)peristance {
    self.baseURLs[self.path] = [baseUrl copy];
    self.orchistrators[self.path] = [[RestOrchestrator alloc] initWithPersistance:peristance];
}

- (NSMutableDictionary *)orchistrators {
    static NSMutableDictionary *orchistrators;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        orchistrators = [NSMutableDictionary dictionary];
    });
    return orchistrators;
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