//
// Created by Tobias Sundstrand on 15-01-29.
//

#import "RestRequestQueue.h"
#import "KTBTaskQueueDelegate.h"
#import <KTBTaskQueue/KTBTaskQueue.h>
#import <AFNetworking/AFNetworking.h>
#import <Realm-Rest/RestRequestBuilder.h>
#import <Realm-Rest/RestRequestQueue.h>

@interface RestRequestQueue() <KTBTaskQueueDelegate>

@property (nonatomic, strong) KTBTaskQueue *queue;

@end


@implementation RestRequestQueue


- (instancetype)initWitPersistance:(RestRequestQueuePeristance)persistance delegate:(NSObject <RestRequestQueueDelegate> *)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.queue = persistance == RestRequestQueuePeristanceDatabase ? [KTBTaskQueue queueAtPath:[self getQueuePath] delegate:self] : [KTBTaskQueue queueInMemoryWithDelegate:self];
    }
    return self;
}

- (void)deactivateQueue {
    [self.queue deleteQueue];
    self.queue = nil;
}

- (NSUInteger)count {
    return self.queue.count;
}

- (void)enqueueRequestWithBaseURL:(NSString *)baseURL
                             path:(NSString *)path
                           method:(NSString *)method
                       parameters:(NSDictionary *)params
                          headers:(NSDictionary *)headers
                         userInfo:(NSDictionary *)userInfo {

    NSParameterAssert(baseURL);
    NSParameterAssert(path);
    NSParameterAssert(method);

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



- (void)taskQueue:(KTBTaskQueue *)queue executeTask:(KTBTask *)task completion:(KTBTaskCompletionBlock)completion {
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[self requestFromTask:task]];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];

    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate queue:self
           requestDidSucceed:operation.request
              responseObject:responseObject
                    userInfo:task.userInfo[RESTUserInfo]];
        completion(KTBTaskStatusSuccess);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([self.delegate queue:self
     shouldAbandonFailedRequest:operation.request
                       response:operation.response
                          error:error
                       userInfo:task.userInfo[RESTUserInfo]]){
            completion(KTBTaskStatusAbandon);
        } else {
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