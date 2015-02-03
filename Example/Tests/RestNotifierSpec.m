#import <OCMock/OCMock.h>
#import <Realm-Rest/RestNotifier.h>
#import "Cat.h"
#import "RLMObject+Rest.h"

SpecBegin(RestNotifier)

    describe(@"RestNotifier", ^{
        __block id observerMock;

        beforeEach(^{
            observerMock = [OCMockObject observerMock];
        });

        afterEach(^{
            [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
        });

        context(@"Success", ^{

            it(@"Should send class specific notification", ^{
                NSString *notification = @"CatSuccessRestNotification";

                [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                                 name:notification
                                                               object:nil];

                NSDictionary *userInfo = @{
                        ClassKey : @"Cat"
                };

                [[observerMock expect] notificationWithName:notification object:nil userInfo:userInfo];

                [RestNotifier notifySuccessWithUserInfo:userInfo];

                [observerMock verify];

            });

            it(@"Should throw witout class in user info", ^{

                expect(^{
                    [RestNotifier notifySuccessWithUserInfo:nil];
                }).to.raise(NSInternalInconsistencyException);

            });

            it(@"Should send general notification", ^{

                [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                                 name:RestNotification
                                                               object:nil];

                NSDictionary *userInfo = @{
                        ClassKey : @"Cat"
                };

                [[observerMock expect] notificationWithName:RestNotification object:nil userInfo:userInfo];

                [RestNotifier notifySuccessWithUserInfo:userInfo];

                [observerMock verify];
            });

            it(@"Should send class specific notification", ^{
                NSString *notification = [Cat restSuccessNotification];

                expect(notification).to.equal(@"CatSuccessRestNotification");

                [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                                 name:notification
                                                               object:nil];

                NSDictionary *userInfo = @{
                        ClassKey : NSStringFromClass([Cat class])
                };

                [[observerMock expect] notificationWithName:notification object:nil userInfo:userInfo];

                [RestNotifier notifySuccessWithUserInfo:userInfo];

                [observerMock verify];

            });
        });
        context(@"failure", ^{
            it(@"Should send class specific notification", ^{
                NSString *notification = @"CatFailureRestNotification";

                [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                                 name:notification
                                                               object:nil];

                NSDictionary *userInfo = @{
                        ClassKey : @"Cat"
                };

                [[observerMock expect] notificationWithName:notification object:nil userInfo:userInfo];

                [RestNotifier notifyFailureWithUserInfo:userInfo];

                [observerMock verify];

            });

            it(@"Should throw witout class in user info", ^{

                expect(^{
                    [RestNotifier notifyFailureWithUserInfo:nil];
                }).to.raise(NSInternalInconsistencyException);

            });

            it(@"Should send general notification", ^{

                [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                                 name:RestNotification
                                                               object:nil];

                NSDictionary *userInfo = @{
                        ClassKey : @"Cat"
                };

                [[observerMock expect] notificationWithName:RestNotification object:nil userInfo:userInfo];

                [RestNotifier notifyFailureWithUserInfo:userInfo];

                [observerMock verify];
            });

            it(@"Should send class specific notification", ^{
                NSString *notification = [Cat restFailureNotification];

                expect(notification).to.equal(@"CatFailureRestNotification");

                [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                                 name:notification
                                                               object:nil];

                NSDictionary *userInfo = @{
                        ClassKey : NSStringFromClass([Cat class])
                };

                [[observerMock expect] notificationWithName:notification object:nil userInfo:userInfo];

                [RestNotifier notifyFailureWithUserInfo:userInfo];

                [observerMock verify];

            });
        });

    });

SpecEnd
