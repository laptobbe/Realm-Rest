#import <Realm-Rest/RestRequestQueue.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

SpecBegin(RestRequestQueue)
    context(@"RestRequestQueue", ^{

        beforeAll(^{
            [Expecta setAsynchronousTestTimeout:10];
        });

        __block RestRequestQueue *queue;
        beforeEach(^{
            queue = [RestRequestQueue sharedInstance];
            queue.persistance = RestRequestQueuePeristanceInMemory;
        });

        afterEach(^{
            [queue emptyQueue];
            [OHHTTPStubs removeAllStubs];
        });

        afterAll(^{
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
            queue.restFailureBlock = ^BOOL(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *userInfo) {
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

        //TODO Add more tests for different network konditions.
    });
SpecEnd
