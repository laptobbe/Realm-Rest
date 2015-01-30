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

- (void)enqueueRequestWithBaseURL:(NSString *)baseURL
                             path:(NSString *)path
                           method:(NSString *)method
                       parameters:(NSDictionary *)params
                   parameterStyle:(RestRequestBuilderParameterStyle)paramStyle
                          headers:(NSDictionary *)headers
                         userInfo:(NSDictionary *)userInfo{

    NSParameterAssert(self.restSuccessBlock);
    NSParameterAssert(self.shouldAbandonFailedRequestBlock);
    NSParameterAssert(baseURL);
    NSParameterAssert(path);
    NSParameterAssert(method);

    if(!self.queue) {
        if(self.persistance == RestRequestQueuePeristanceDatabase) {
            self.queue = [KTBTaskQueue queueAtPath:[self getQueuePath] delegate:self];
        }else {
            self.queue = [KTBTaskQueue queueInMemoryWithDelegate:self];
        }
    }

    NSMutableDictionary *taskUserInfo = [NSMutableDictionary dictionary];

    if(baseURL) {
        taskUserInfo[RESTURL] = baseURL;
    }
    if(path) {
       taskUserInfo[RESTPath] = path;
    }

    if(method) {
        taskUserInfo[RESTMethod] = method;
    }

    if(paramStyle) {
        taskUserInfo[RESTParameterStyle] = @(paramStyle);
    }

    if(params) {
        taskUserInfo[RESTParameters] = params;
    }

    if(headers) {
        taskUserInfo[RESTHeaders] = headers;
    }

    if(userInfo) {
        taskUserInfo[RESTUserInfo] = userInfo;
    }

    KTBTask *task = [KTBTask taskWithName:[NSString stringWithFormat:@"%@ %@%@", method, baseURL, path]
                                 userInfo:taskUserInfo
                            availableDate:[NSDate date]
                               maxRetries:KTBTaskAlwaysRetry
                               useBackoff:YES];

    [self.queue enqueueTask:task];

}

- (void)emptyQueue {
    [self.queue deleteQueue];
    self.queue = nil;
}

- (void)taskQueue:(KTBTaskQueue *)queue executeTask:(KTBTask *)task completion:(KTBTaskCompletionBlock)completion {
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[self requestFromTask:task]];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];

    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.restSuccessBlock(operation.request, responseObject, task.userInfo[RESTUserInfo]);
        completion(KTBTaskStatusSuccess);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(self.shouldAbandonFailedRequestBlock(operation.request, operation.response, error, task.userInfo[RESTUserInfo])) {
            completion(KTBTaskStatusAbandon);
        }else {
            completion(KTBTaskStatusFailure);
        }
    }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}

- (NSURLRequest *)requestFromTask:(KTBTask *)task {
    return [RestRequestBuilder requestWithDictionary:task.userInfo];
}

- (NSString *)getQueuePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths lastObject] stringByAppendingPathComponent:@"requestqueue.db"];
}


@end