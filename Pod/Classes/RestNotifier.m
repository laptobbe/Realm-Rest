//
// Created by Tobias Sundstrand on 15-02-02.
//

#import "RestNotifier.h"
#import "RLMObject+Rest.h"

NSString *const RequestIdKey = @"requestId";
NSString *const ClassKey = @"class";
NSString *const RealmTypeKey = @"realmType";
NSString *const RealmKey = @"realm";
NSString *const UserInfoKey = @"user_info";
NSString *const BaseUrlKey = @"baseurl";
NSString *const PathUrlKey = @"path";
NSString *const MethodKey = @"method";
NSString *const PrimaryKeyValueKey = @"primary_key_value";
NSString *const ResponseKey = @"response";

NSString *const RestNotification = @"RestNotification";

@implementation RestNotifier

+ (void)notifySuccessWithUserInfo:(NSDictionary *)dictionary {
    [self notifyWithUserInfo:dictionary notification:@selector(restSuccessNotification)];
}

+ (void)notifyFailureWithUserInfo:(NSDictionary *)dictionary {
    [self notifyWithUserInfo:dictionary notification:@selector(restFailureNotification)];
}

+ (void)notifyWithUserInfo:(NSDictionary *)dictionary notification:(SEL)sel{

    NSString *className = dictionary[ClassKey];
    NSString * requestId = dictionary[RequestIdKey];
    if(!className || !requestId) {
        [NSException raise:NSInternalInconsistencyException format:@"Need to have a class and requestId in userInfo to be able to notify"];
    }

    NSString *notification = [NSClassFromString(className) performSelector:sel];

    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] postNotificationName:RestNotification object:nil userInfo:dictionary];

}

@end