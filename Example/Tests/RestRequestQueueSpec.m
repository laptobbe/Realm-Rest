#import <Realm-Rest/RestRequestQueue.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

SpecBegin(RestRequestQueue)
    context(@"RestRequestQueue", ^{
        __block RestRequestQueue *queue;
        beforeEach(^{
            queue = [RestRequestQueue sharedInstance];
            queue.persistance = RestRequestQueuePeristanceInMemory;
        });

        afterEach(^{
            [OHHTTPStubs removeAllStubs];
        });



    });
SpecEnd
