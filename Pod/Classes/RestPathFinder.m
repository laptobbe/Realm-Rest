//
//  RestPathFinder.m
//  Pods
//
//  Created by Tobias Sundstrand on 2015-01-25.
//
//

#import <Realm-Rest/RestPathFinder.h>
#import <Realm-Rest/RLMRealm+Rest.h>
#import <Realm/Realm.h>
#import <NSString-UrlEncode/NSString+URLEncode.h>
#import "RestPathFinder.h"

static NSString *const DefaultFormat = @"%@/%%@";

@implementation RestPathFinder

+ (NSString *)findPathForObject:(RLMObject<RestModelObjectProtocol> *)object forType:(RestRequestType)type {

    if(![[object class] respondsToSelector:@selector(primaryKey)] || ![[object class] primaryKey] || ![object valueForKey:[[object class] primaryKey]]){
        [NSException raise:NSInternalInconsistencyException format:@"Class %@ does not have a primary key", [[object class] className]];
    }

    NSString *className = [[[[object class] className] lowercaseString] URLEncode];
    NSString *primaryKey = [[[object valueForKey:[[object class] primaryKey]] lowercaseString] URLEncode];

    switch (type) {
        case RestRequestTypeGet:
            return [self pathForObject:object withClassName:className primaryKey:primaryKey selector:@selector(restPathToResourceGET)];
        case RestRequestTypePost:
            return [self pathForObject:object withClassName:className primaryKey:primaryKey selector:@selector(restPathToResourcePOST)];
        case RestRequestTypePut:
            return [self pathForObject:object withClassName:className primaryKey:primaryKey selector:@selector(restPathToResourcePUT)];
        case RestRequestTypeDelete:
            return [self pathForObject:object withClassName:className primaryKey:primaryKey selector:@selector(restPathToResourceDELETE)];
    }
    return nil;
}

+ (NSString *)pathForObject:(RLMObject<RestModelObjectProtocol> *)object withClassName:(NSString *)name primaryKey:(NSString *)key selector:(SEL)selector{
    if ([object respondsToSelector:selector]) {
        return [[object performSelector:selector] lowercaseString];
    }

    return [self defaultPathForName:name key:key];
}


+ (NSString *)findPathForClass:(Class)class forType:(RestRequestType)type {

    NSString *className = [[[class className] lowercaseString] URLEncode];

    switch (type) {

        case RestRequestTypeGet:
            return [self pathForClass:class className:className selector:@selector(restPathToResourceGET)];
        case RestRequestTypePost:
            return [self pathForClass:class className:className selector:@selector(restPathToResourcePOST)];
        case RestRequestTypePut:
            return [self pathForClass:class className:className selector:@selector(restPathToResourcePUT)];
        case RestRequestTypeDelete:
            return [self pathForClass:class className:className selector:@selector(restPathToResourceDELETE)];
    }
    return nil;
}

+ (NSString *)pathForClass:(Class)class className:(NSString *)name selector:(SEL)selector {
    if([class respondsToSelector:selector]) {
        return [[class performSelector:selector] lowercaseString];
    } else {
        return [name stringByAppendingString:@"s"];
    };
}


+ (NSString *)pathForPrimaryKey:(NSString *)key format:(NSString *)format {
    return [NSString stringWithFormat:format, key];
}

+ (NSString *)defaultPathForName:(NSString *)name key:(NSString *)key {
    return [self pathForPrimaryKey:key format:[NSString stringWithFormat:DefaultFormat, name]];
}

+ (NSString *)findBaseURLForModelClass:(Class)class realm:(RLMRealm *)realm {
    if ([class respondsToSelector:@selector(baseURL)]) {
        return [class baseURL];
    }

    return realm.baseURL;
}

+ (NSString *)httpMethodFromRequestType:(RestRequestType)type {
    switch (type) {
        case RestRequestTypeGet:
            return @"GET";
        case RestRequestTypePost:
            return @"POST";
        case RestRequestTypePut:
            return @"PUT";
        case RestRequestTypeDelete:
            return @"DELETE";
    }
    return nil;
}
@end
