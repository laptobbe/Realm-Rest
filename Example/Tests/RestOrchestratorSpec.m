#import <Realm-Rest/RestRequestQueue.h>
#import <Realm-Rest/RestOrchestrator.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <Realm/Realm.h>
#import <Realm+JSON/RLMObject+JSON.h>
#import "Cat.h"
#import <Realm-Rest/RLMRealm+Rest.h>

static NSString *const RealmIdentifier = @"test";

SpecBegin(RestOrchestrator)

    describe(@"RestOrchestator", ^{

        beforeAll(^{
            [Expecta setAsynchronousTestTimeout:10];
        });

        __block RestRequestQueue *queue;
        __block RLMRealm *realm;
        __block RLMNotificationToken *notificationToken;
        beforeEach(^{
            [[RestOrchestrator sharedInstance] initiateWithPersistance:RestRequestQueuePeristanceInMemory];
            realm = [RLMRealm inMemoryRealmWithIdentifier:RealmIdentifier];
            realm.baseURL = @"http://api.example.com";
        });

        afterEach(^{
            [realm removeNotification:notificationToken];
            notificationToken = nil;
            realm = nil;
            [queue deactivateQueue];
            [OHHTTPStubs removeAllStubs];
        });

        context(@"Getting back JSON", ^{
            it(@"Should save model in Realm", ^{
                __block BOOL success = NO;

                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return YES;
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithJSONObject:@{@"name":@"Jerry", @"speed": @15}
                                                            statusCode:200
                                                               headers:nil];
                }];


                notificationToken = [realm addNotificationBlock:^(NSString *notification, RLMRealm *notificationRealm) {
                    if([[Cat objectInRealm:notificationRealm withPrimaryKeyValue:@"Jerry"] speed] == 15) {
                        success = YES;
                    }
                }];
                
                [RestOrchestrator restForModelClass:[Cat class]
                                        requestType:RestRequestTypeGet
                                         parameters:nil
                                            headers:nil
                                              realm:realm
                                    realmIdentifier:RealmIdentifier];


                expect(success).will.beTruthy();

            });
        });
    });

SpecEnd
