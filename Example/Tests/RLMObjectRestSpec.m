#import <Realm-Rest/RLMObject+Rest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <Realm-Rest/RestRequestQueue.h>
#import <Realm-Rest/RLMRealm+Rest.h>
#import <Realm+JSON/RLMObject+JSON.h>
#import <Realm/Realm.h>
#import <Realm-Rest/RestOrchestrator.h>
#import <Realm-Rest/RestNotifier.h>
#import "Cat.h"
#import "Mouse.h"

static NSString *const realmIdentifier = @"test";

SpecBegin(RLMObject)

    describe(@"RLMObject with Rest addons", ^{

        __block RLMRealm *realm;
        __block NSURLRequest *request;
        __block RLMNotificationToken *notificationToken;
        __block id nsNotificationToken;

        beforeAll(^{
            [[RestOrchestrator sharedInstance] initiateWithPersistance:RestRequestQueuePeristanceInMemory];
        });

        beforeEach(^{
            realm = [RLMRealm inMemoryRealmWithIdentifier:realmIdentifier];
            realm.baseURL = @"http://api.example.com";
        });

        afterEach(^{
            [realm removeNotification:notificationToken];
            notificationToken = nil;
            realm = nil;
            [OHHTTPStubs removeAllStubs];
            [[NSNotificationCenter defaultCenter] removeObserver:nsNotificationToken];
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
                         realmIdentifier:realmIdentifier
                                  action:nil];

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
                         realmIdentifier:realmIdentifier
                                  action:nil];

                expect(request.URL.absoluteString).will.equal(@"http://api.example.com/cats");
                expect(request.HTTPBody).will.beFalsy();
                expect(success).will.beTruthy();
            });

            it(@"Should include request id in notification", ^{
                __block NSString *actualIdentifier;
                NSArray *jsonObject = @[
                        @{@"name":@"Misse", @"speed":@12},
                        @{@"name":@"Kisse", @"speed":@2},
                        @{@"name":@"Disse", @"speed":@53}
                ];

                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *stubRequest) {
                    return YES;
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *stubRequest) {
                    return [OHHTTPStubsResponse responseWithJSONObject:jsonObject
                                                            statusCode:200
                                                               headers:nil];
                }];

                nsNotificationToken= [[NSNotificationCenter defaultCenter] addObserverForName:[Cat restSuccessNotification]
                                                                                       object:nil
                                                                                        queue:[NSOperationQueue mainQueue]
                                                                                   usingBlock:^(NSNotification *note) {
                                                                                       actualIdentifier = note.userInfo[RequestIdKey];
                                                                                   }];

                NSString *identifier = [Cat restWithRequestType:RestRequestTypeGet
                                                     parameters:nil
                                                        headers:nil
                                                          realm:realm
                                                realmIdentifier:realmIdentifier
                                                         action:nil];

                expect(identifier).to.beTruthy();
                expect(actualIdentifier).will.equal(identifier);
            });

            it(@"Should call the success block", ^{
                __block NSArray *primaryKeys;
                NSArray *jsonObject = @[
                        @{@"name":@"Misse", @"speed":@12},
                        @{@"name":@"Kisse", @"speed":@2},
                        @{@"name":@"Disse", @"speed":@53}
                ];

                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *stubRequest) {
                    return YES;
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *stubRequest) {
                    return [OHHTTPStubsResponse responseWithJSONObject:jsonObject
                                                            statusCode:200
                                                               headers:nil];
                }];

                [Cat restWithRequestType:RestRequestTypeGet
                              parameters:nil
                                 headers:nil
                                   realm:realm
                         realmIdentifier:realmIdentifier
                                  action:nil
                                 success:^(id primaryKey) {
                                     primaryKeys = primaryKey;
                                 }
                                 failure:nil];

                NSArray *expected = @[@"Misse", @"Kisse", @"Disse"];
                expect(primaryKeys).will.beTruthy();
                expect(primaryKeys).will.equal(expected);
            });

            it(@"Should call the failure block", ^{
                __block NSError *expected = [NSError errorWithDomain:NSURLErrorDomain
                                                             code:NSURLErrorNotConnectedToInternet
                                                         userInfo:nil];
                __block NSError *actual;

                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *stubRequest) {
                    return YES;
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *stubRequest) {
                    return [OHHTTPStubsResponse responseWithError:expected];
                }];

                [Cat restWithRequestType:RestRequestTypeGet
                              parameters:nil
                                 headers:nil
                                   realm:realm
                         realmIdentifier:realmIdentifier
                                  action:nil
                                 success:nil
                                 failure:^(NSError *error, NSDictionary *userInfo) {
                                     actual = error;
                                 }];

                expect(actual).will.beTruthy();
                expect(actual.domain).will.equal(expected.domain);
                expect(actual.code).will.equal(expected.code);
            });
        });
    });

SpecEnd
