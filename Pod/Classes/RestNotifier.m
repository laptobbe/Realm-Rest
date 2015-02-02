//
// Created by Tobias Sundstrand on 15-02-02.
//

#import "RestNotifier.h"

NSString *const ClassKey = @"class";
NSString *const RealmTypeKey = @"realmType";
NSString *const RealmKey = @"realm";
NSString *const BaseUrlKey = @"baseurl";
NSString *const PathUrlKey = @"path";
NSString *const MethodKey = @"method";
NSString *const ObjectKey = @"object";

NSString *const RestNotification = @"RestNotification";

@implementation RestNotifier

+ (void)notifyWithUserInfo:(NSDictionary *)dictionary {

    NSObject *className = dictionary[ClassKey];
    if(!className) {
        [NSException raise:NSInternalInconsistencyException format:@"Need to have a class in userInfo to be able to notify"];
    }

    NSString *notification = [NSString stringWithFormat:@"%@%@", className, RestNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] postNotificationName:RestNotification object:nil userInfo:dictionary];
}

@end