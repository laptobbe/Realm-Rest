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

static NSString *const DefaultFormat = @"%@/%%@";

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

+ (NSString *)getAllPathForObject:(RLMObject *)object withClassName:(NSString *)name {
    if([[object class] respondsToSelector:@selector(restPathToResources)]) {
        return [[object class] restPathToResources];
    } else {
        return [name stringByAppendingString:@"s"];
    }
};

+ (NSString *)deletePathForObject:(RLMObject *)object withClassName:(NSString *)name primaryKey:(NSString *)key {
    if([[object class] respondsToSelector:@selector(restPathToResourceDELETE)]) {
        return [self pathForPrimaryKey:key format:[[object class] restPathToResourceDELETE]];
    }

    return [self defaultPathForObject:object name:name key:key];
}

+ (NSString *)putPathForObject:(RLMObject *)object withClassName:(NSString *)name primaryKey:(NSString *)key {
    if([[object class] respondsToSelector:@selector(restPathToResourcePUT)]) {
        return [self pathForPrimaryKey:key format:[[object class] restPathToResourcePUT]];
    }
    return [self defaultPathForObject:object name:name key:key];
}

+ (NSString *)postPathForObject:(RLMObject *)object withClassName:(NSString *)name primaryKey:(NSString *)key {
    if([[object class] respondsToSelector:@selector(restPathToResourcePOST)]) {
        return [self pathForPrimaryKey:key format:[[object class] restPathToResourcePOST]];
    }

    return [self defaultPathForObject:object name:name key:key];
}

+ (NSString *)getPathForObject:(RLMObject *)object withClassName:(NSString *)name primaryKey:(NSString *)key {
    if([[object class] respondsToSelector:@selector(restPathToResourceGET)]) {
        return [self pathForPrimaryKey:key format:[[object class] restPathToResourceGET]];
    }

    return [self defaultPathForObject:object name:name key:key];
}

+ (NSString *)pathForPrimaryKey:(NSString *)key format:(NSString *)format {
    return [NSString stringWithFormat:format, key];
}

+ (NSString *)defaultPathForObject:(RLMObject *)object name:(NSString *)name key:(NSString *)key {
    if([[object class] respondsToSelector:@selector(restPathToResource)]) {
        return [self pathForPrimaryKey:key format:[[object class] restPathToResource]];
    }

    return [self pathForPrimaryKey:key format:[NSString stringWithFormat:DefaultFormat, name]];
}



@end
