#import <Realm-Rest/Realm-Rest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <Realm/Realm.h>
#import <Realm+JSON/RLMObject+JSON.h>
#import "Cat.h"


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
            realm = [RLMRealm inMemoryRealmWithIdentifier:RealmIdentifier];
            [realm setBaseUrl:@"http://api.example.com" queuePersistance:RestRequestQueuePeristanceInMemory];
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

                [realm.orchistrator restForModelClass:[Cat class]
                                          requestType:RestRequestTypeGet
                                            requestId:@"testrequest"
                                           parameters:nil
                                              headers:nil
                                                realm:realm
                                      realmIdentifier:RealmIdentifier
                                               action:nil];

                expect(success).will.beTruthy();

            });
        });
    });

SpecEnd
