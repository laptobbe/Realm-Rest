//
// Created by Tobias Sundstrand on 15-01-29.
//

#import "RestRequestQueue.h"
#import "KTBTaskQueueDelegate.h"
#import <KTBTaskQueue/KTBTaskQueue.h>
#import <AFNetworking/AFNetworking.h>
#import <Realm-Rest/RestRequestBuilder.h>

@interface RestRequestQueue() <KTBTaskQueueDelegate>

@property (nonatomic, strong) KTBTaskQueue *queue;

@end


@implementation RestRequestQueue


+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static RestRequestQueue *queue;
    dispatch_once(&once, ^{
        queue = [RestRequestQueue new];
        queue.persistance = RestRequestQueuePeristanceDatabase;
    });
    return queue;
}

- (void)enqueueRequest:(NSURLRequest *)request {
    if(!self.queue) {
        if(self.persistance == RestRequestQueuePeristanceDatabase) {
            self.queue = [KTBTaskQueue queueAtPath:[self getQueuePath] delegate:self];
        }else {
            self.queue = [KTBTaskQueue queueInMemoryWithDelegate:self];
        }
    }


}



- (void)emptyQueue {

}

- (void)taskQueue:(KTBTaskQueue *)queue executeTask:(KTBTask *)task completion:(KTBTaskCompletionBlock)completion {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [operationManager HTTPRequestOperationWithRequest:[self requestFromTask:task]
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                              }
                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                              }];
}

- (NSURLRequest *)requestFromTask:(KTBTask *)task {
    return [RestRequestBuilder requestWithDictionary:task.userInfo];
}

- (NSString *)getQueuePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths lastObject] stringByAppendingPathComponent:@"requestqueue.db"];
}


@end