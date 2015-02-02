//
// Created by Tobias Sundstrand on 15-02-02.
//

#import <Realm-Rest/RestNotifier.h>
#import "RLMObject+Rest.h"


@implementation RLMObject (Rest)
+ (NSString *)restNotification {
    return [NSString stringWithFormat:@"%@%@", NSStringFromClass(self), RestNotification];
}

@end