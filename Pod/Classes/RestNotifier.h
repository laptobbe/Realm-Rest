//
// Created by Tobias Sundstrand on 15-02-02.
//

#import <Foundation/Foundation.h>

extern NSString *const RestNotification;

extern NSString *const RequestIdKey;
extern NSString *const ClassKey;
extern NSString *const RealmTypeKey;
extern NSString *const RealmKey;
extern NSString *const ActionKey;
extern NSString *const BaseUrlKey;
extern NSString *const PathUrlKey;
extern NSString *const MethodKey;
extern NSString *const PrimaryKeyValueKey;
extern NSString *const ResponseKey;

@interface RestNotifier : NSObject

+ (void)notifySuccessWithUserInfo:(NSDictionary *)dictionary;

+ (void)notifyFailureWithUserInfo:(NSDictionary *)dictionary;
@end