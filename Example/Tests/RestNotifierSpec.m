#import <OCMock/OCMock.h>
#import <Realm-Rest/RestNotifier.h>

SpecBegin(RestNotifier)

    describe(@"RestNotifier", ^{
        it(@"Should send class specific notification", ^{
            NSString *notification = @"CatRestNotification";
            id observerMock = [OCMockObject observerMock];
            [[NSNotificationCenter defaultCenter] addMockObserver:observerMock
                                                             name:notification
                                                           object:nil];

            [[observerMock expect] notificationWithName:notification object:nil];

            [RestNotifier notifyWithUserInfo:@{
                  ClassKey : @"Cat"
            }];

            [observerMock verify];
            [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
        });
    });

SpecEnd
