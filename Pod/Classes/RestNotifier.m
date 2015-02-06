//
// Created by Tobias Sundstrand on 15-02-02.
//

#import "RestNotifier.h"
#import "RLMObject+Rest.h"

NSString *const RequestIdKey = @"requestId";
NSString *const ClassKey = @"class";
NSString *const RealmTypeKey = @"realmType";
NSString *const RealmKey = @"realm";
NSString *const BaseUrlKey = @"baseurl";
NSString *const PathUrlKey = @"path";
NSString *const MethodKey = @"method";
NSString *const PrimaryKeyValueKey = @"primary_key_value";
NSString *const ResponseKey = @"response";

NSString *const RestNotification = @"RestNotification";

@implementation RestNotifier

+ (void)notifySuccessWithUserInfo:(NSDictionary *)dictionary {

    NSString *className = dictionary[ClassKey];
    if(!className) {
        [NSException raise:NSInternalInconsistencyException format:@"Need to have a class in userInfo to be able to notify"];
    }

    NSString *notification = [NSClassFromString(className) restSuccessNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] postNotificationName:RestNotification object:nil userInfo:dictionary];
}

+ (void)notifyFailureWithUserInfo:(NSDictionary *)dictionary {
    NSString *className = dictionary[ClassKey];
    if(!className) {
        [NSException raise:NSInternalInconsistencyException format:@"Need to have a class in userInfo to be able to notify"];
    }

    NSString *notification = [NSClassFromString(className) restFailureNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] postNotificationName:RestNotification object:nil userInfo:dictionary];

}

@end