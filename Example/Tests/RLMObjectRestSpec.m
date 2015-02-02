#import <Realm-Rest/RLMObject+Rest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <Realm-Rest/RestRequestQueue.h>
#import <Realm-Rest/RLMRealm+Rest.h>
#import <Realm+JSON/RLMObject+JSON.h>
#import <Realm/Realm.h>
#import "Cat.h"
#import "Mouse.h"

static NSString *const realmIdentifier = @"test";

SpecBegin(RLMObject)

    describe(@"RLMObject with Rest addons", ^{

        __block RestRequestQueue *queue;
        __block RLMRealm *realm;
        __block NSURLRequest *request;
        __block RLMNotificationToken *notificationToken;

        beforeEach(^{

            queue = [RestRequestQueue sharedInstance];
            [queue activateQueueWithPersistance:RestRequestQueuePeristanceInMemory];
            realm = [RLMRealm inMemoryRealmWithIdentifier:realmIdentifier];
            realm.baseURL = @"http://api.example.com";
        });

        afterEach(^{
            [realm removeNotification:notificationToken];
            notificationToken = nil;
            realm = nil;
            [queue deactivateQueue];
            [OHHTTPStubs removeAllStubs];
        });
        context(@"Object", ^{
            it(@"Should add JSON parameters", ^{
                NSDictionary *jsonObject = @{@"name":@"Misse", @"speed":@12};
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                                   options:0
                                                                     error:nil];

                [realm beginWriteTransaction];
                Cat *cat = [Cat createInRealm:realm withObject:jsonObject];
                [realm commitWriteTransaction];

                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *stubRequest) {
                    request = stubRequest;
                    return YES;
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *stubRequest) {
                    return [OHHTTPStubsResponse responseWithJSONObject:jsonObject
                                                            statusCode:200
                                                               headers:nil];
                }];

                [cat restWithRequestType:RestRequestTypeGet
                              parameters:nil
                                 headers:nil
                                   realm:realm
                         realmIdentifier:realmIdentifier];

                expect(request.URL.absoluteString).will.equal(@"http://api.example.com/cat/misse");
                expect(request.HTTPBody).will.equal(jsonData);
            });
        });

        context(@"Class", ^{
            it(@"Should add JSON parameters", ^{
                __block BOOL success = NO;
                NSArray *jsonObject = @[
                        @{@"name":@"Misse", @"speed":@12},
                        @{@"name":@"Kisse", @"speed":@2},
                        @{@"name":@"Disse", @"speed":@53}
                ];



                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *stubRequest) {
                    request = stubRequest;
                    return YES;
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *stubRequest) {
                    return [OHHTTPStubsResponse responseWithJSONObject:jsonObject
                                                            statusCode:200
                                                               headers:nil];
                }];

                notificationToken = [realm addNotificationBlock:^(NSString *notification, RLMRealm *notificationRealm) {
                    if([[Cat objectInRealm:notificationRealm withPrimaryKeyValue:@"Misse"] speed] == 12 &&
                            [[Cat objectInRealm:notificationRealm withPrimaryKeyValue:@"Kisse"] speed] == 2 &&
                            [[Cat objectInRealm:notificationRealm withPrimaryKeyValue:@"Disse"] speed] == 53) {
                        success = YES;
                    }
                }];

                [Cat restWithRequestType:RestRequestTypeGet
                              parameters:nil
                                 headers:nil
                                   realm:realm
                         realmIdentifier:realmIdentifier];

                expect(request.URL.absoluteString).will.equal(@"http://api.example.com/cats");
                expect(request.HTTPBody).will.beFalsy();
                expect(success).will.beTruthy();
            });
        });

        context(@"Abandon request", ^{
            it(@"Abandons if implemeted", ^{

                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *stubRequest) {
                    return YES;
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *stubRequest) {
                    return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                                                      code:NSURLErrorNotConnectedToInternet
                                                                                  userInfo:nil]];
                }];

                [Mouse restWithRequestType:RestRequestTypeGet
                                parameters:nil
                                   headers:nil
                                     realm:realm
                           realmIdentifier:realmIdentifier];

                [Mouse restWithRequestType:RestRequestTypeGet
                                parameters:nil
                                   headers:nil
                                     realm:realm
                           realmIdentifier:realmIdentifier];

                [Mouse restWithRequestType:RestRequestTypeGet
                                parameters:nil
                                   headers:nil
                                     realm:realm
                           realmIdentifier:realmIdentifier];

                expect([[RestRequestQueue sharedInstance] count]).to.equal(3);
                expect([[RestRequestQueue sharedInstance] count]).will.equal(0);
            });
        });
    });

SpecEnd
