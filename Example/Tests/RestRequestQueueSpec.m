#import <Realm-Rest/RestRequestQueue.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

SpecBegin(RestRequestQueue)
    context(@"RestRequestQueue", ^{

        beforeAll(^{
            [Expecta setAsynchronousTestTimeout:40];
        });

        __block RestRequestQueue *queue;
        beforeEach(^{
            queue = [RestRequestQueue sharedInstance];
            [queue activateQueueWithPersistance:RestRequestQueuePeristanceInMemory];
        });

        afterEach(^{
            [queue deactivateQueue];
            [OHHTTPStubs removeAllStubs];
        });

        it(@"Should throw without success block", ^{
            expect ( ^{
                [queue enqueueRequestWithBaseURL:nil
                                            path:nil
                                          method:nil
                                      parameters:nil
                                  parameterStyle:RestRequestBuilderParameterStyleNone
                                         headers:nil
                                        userInfo:nil];
            }

            ).to.raise(NSInternalInconsistencyException);
        });

        it(@"Should throw without failure block", ^{
            expect ( ^{
                queue.restSuccessBlock = ^(NSURLRequest *request, id responseObject, NSDictionary *userInfo) {

                };
                [queue enqueueRequestWithBaseURL:nil
                                            path:nil
                                          method:nil
                                      parameters:nil
                                  parameterStyle:RestRequestBuilderParameterStyleNone
                                         headers:nil
                                        userInfo:nil];
            }

            ).to.raise(NSInternalInconsistencyException);
        });

        it(@"Should call success block on 200", ^{

            __block BOOL success = NO;
            queue.restSuccessBlock = ^(NSURLRequest *request, id responseObject, NSDictionary *userInfo) {
                success = YES;
            };
            queue.shouldAbandonFailedRequestBlock = ^BOOL(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *userInfo) {
                NSLog(error.description);
                success = NO;
                return NO;
            };

            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                 return YES;
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithJSONObject:@{}
                                                        statusCode:200
                                                           headers:nil];
            }];

            [queue enqueueRequestWithBaseURL:@"http://api.example.com"
                                        path:@"/cat/22"
                                      method:@"GET"
                                  parameters:nil
                              parameterStyle:RestRequestBuilderParameterStyleNone
                                     headers:nil
                                    userInfo:nil];

            expect(success).will.beTruthy();
        });

        it(@"Should call failure block on network error", ^{

            __block BOOL failure = NO;
            queue.restSuccessBlock = ^(NSURLRequest *request, id responseObject, NSDictionary *userInfo) {
                failure = NO;
            };
            queue.shouldAbandonFailedRequestBlock = ^BOOL(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *userInfo) {
                failure = YES;
                return NO;
            };

            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                                                  code:NSURLErrorNotConnectedToInternet
                                                                              userInfo:nil]];
            }];

            [queue enqueueRequestWithBaseURL:@"http://api.example.com"
                                        path:@"/cat/22"
                                      method:@"GET"
                                  parameters:nil
                              parameterStyle:RestRequestBuilderParameterStyleNone
                                     headers:nil
                                    userInfo:nil];

            expect(failure).will.beTruthy();
        });


        it(@"Should should keep retrying the same request before the next one", ^{

            __block int count = 0;
            __block int wrongCount = 0;
            queue.restSuccessBlock = ^(NSURLRequest *request, id responseObject, NSDictionary *userInfo) {
                XCTFail(@"Should not be called");
            };
            queue.shouldAbandonFailedRequestBlock = ^BOOL(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *userInfo) {
                if([request.URL.host isEqualToString:@"wrong.api.example"]) {
                    wrongCount++;
                }else {
                    count++;
                }
                return NO;
            };

            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                                                  code:NSURLErrorNotConnectedToInternet
                                                                              userInfo:nil]];
            }];

            [queue enqueueRequestWithBaseURL:@"http://api.example.com"
                                        path:@"/cat/22"
                                      method:@"GET"
                                  parameters:nil
                              parameterStyle:RestRequestBuilderParameterStyleNone
                                     headers:nil
                                    userInfo:nil];

            [queue enqueueRequestWithBaseURL:@"http://wrong.example.com"
                                        path:@"/cat/22"
                                      method:@"GET"
                                  parameters:nil
                              parameterStyle:RestRequestBuilderParameterStyleNone
                                     headers:nil
                                    userInfo:nil];

            expect(count).will.beGreaterThan(2);
            expect(wrongCount).will.equal(0);
        });


        it(@"Should should keep retrying the same request before the next one", ^{

            __block int count = 0;
            __block int wrongCount = 0;
            queue.restSuccessBlock = ^(NSURLRequest *request, id responseObject, NSDictionary *userInfo) {
                XCTFail(@"Should not be called");
            };
            queue.shouldAbandonFailedRequestBlock = ^BOOL(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *userInfo) {
                if([request.URL.host isEqualToString:@"wrong.api.example"]) {
                    wrongCount++;
                }else {
                    count++;
                }
                return NO;
            };

            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                                                  code:NSURLErrorNotConnectedToInternet
                                                                              userInfo:nil]];
            }];

            [queue enqueueRequestWithBaseURL:@"http://api.example.com"
                                        path:@"/cat/22"
                                      method:@"GET"
                                  parameters:nil
                              parameterStyle:RestRequestBuilderParameterStyleNone
                                     headers:nil
                                    userInfo:nil];

            [queue enqueueRequestWithBaseURL:@"http://wrong.example.com"
                                        path:@"/cat/22"
                                      method:@"GET"
                                  parameters:nil
                              parameterStyle:RestRequestBuilderParameterStyleNone
                                     headers:nil
                                    userInfo:nil];

            [queue enqueueRequestWithBaseURL:@"http://wrong.example.com"
                                        path:@"/cat/22"
                                      method:@"GET"
                                  parameters:nil
                              parameterStyle:RestRequestBuilderParameterStyleNone
                                     headers:nil
                                    userInfo:nil];

            expect(count).will.beGreaterThan(2);
            expect(wrongCount).will.equal(0);
        });
    });
SpecEnd
