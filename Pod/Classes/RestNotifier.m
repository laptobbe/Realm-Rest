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
    NSString *notification = [NSString stringWithFormat:@"%@%@",dictionary[ClassKey], RestNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil];
}

@end