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

        it(@"Should send class specific notification", ^{
            NSString *notification = @"CatRestNotification";

            [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                             name:notification
                                                           object:nil];

            NSDictionary *userInfo = @{
                    ClassKey : @"Cat"
            };

            [[observerMock expect] notificationWithName:notification object:nil userInfo:userInfo];

            [RestNotifier notifyWithUserInfo:userInfo];

            [observerMock verify];

        });

        it(@"Should throw witout class in user info", ^{

            expect(^{
                [RestNotifier notifyWithUserInfo:nil];
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

            [RestNotifier notifyWithUserInfo:userInfo];

            [observerMock verify];
        });

        it(@"Should send class specific notification", ^{
            NSString *notification = [Cat restNotification];

            expect(notification).to.equal(@"CatRestNotification");

            [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                             name:notification
                                                           object:nil];

            NSDictionary *userInfo = @{
                    ClassKey : NSStringFromClass([Cat class])
            };

            [[observerMock expect] notificationWithName:notification object:nil userInfo:userInfo];

            [RestNotifier notifyWithUserInfo:userInfo];

            [observerMock verify];

        });
        
    });

SpecEnd
