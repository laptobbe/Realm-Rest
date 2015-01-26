//
//  RestPathFinder.m
//  Pods
//
//  Created by Tobias Sundstrand on 2015-01-25.
//
//

#import <Realm-Rest/RestPathFinder.h>
#import <Realm/Realm/RLMObject.h>
#import <NSString-UrlEncode/NSString+URLEncode.h>
#import "RestPathFinder.h"
#import "RestModelObjectProtocol.h"

@implementation RestPathFinder

+ (NSString *)findPathForObject:(RLMObject *)object forType:(RestRequestType)type {
    if(![[object class] respondsToSelector:@selector(primaryKey)] || ![[object class] primaryKey] || ![object valueForKey:[[object class] primaryKey]]){
        [NSException raise:NSInternalInconsistencyException format:@"Class %@ does not have a primary key", [[object class] className]];
    }
    
    NSString *className = [[[[object class] className] lowercaseString] URLEncode];
    NSString *primaryKey = [[[object valueForKey:[[object class] primaryKey]] lowercaseString] URLEncode];

    switch (type) {

        case RestRequestTypeGetAll:
            return [self getAllPathForObject:object withClassName:className];
        case RestRequestTypeGet:
            return [self getPathForObject:object withClassName:className primaryKey:primaryKey];
        case RestRequestTypePost:
            return [self postPathForObject:object withClassName:className primaryKey:primaryKey];
        case RestRequestTypePut:
            return [self putPathForObject:object withClassName:className primaryKey:primaryKey];
        case RestRequestTypeDelete:
            return [self deletePathForObject:object withClassName:className primaryKey:primaryKey];
    }
}

+ (NSString *)deletePathForObject:(RLMObject *)object withClassName:(NSString *)name primaryKey:(NSString *)key {
    return nil;
}

+ (NSString *)putPathForObject:(RLMObject *)object withClassName:(NSString *)name primaryKey:(NSString *)key {
    return nil;
}

+ (NSString *)postPathForObject:(RLMObject *)object withClassName:(NSString *)name primaryKey:(NSString *)key {
    return nil;
}

+ (NSString *)getPathForObject:(RLMObject *)object withClassName:(NSString *)name primaryKey:(NSString *)key {
    NSString *path = [NSString string];
    path = [path stringByAppendingPathComponent:name];
    path = [path stringByAppendingPathComponent:key];
    return  path;
}

+ (NSString *)getAllPathForObject:(RLMObject *)object withClassName:(NSString *)name {
    if([[object class] respondsToSelector:@selector(restPathToResources)]) {
        return [[object class] restPathToResources];
    } else {
        return [name stringByAppendingString:@"s"];
    }
};

@end
