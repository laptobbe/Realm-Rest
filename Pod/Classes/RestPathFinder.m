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

@implementation RestPathFinder

+ (NSString *)findPathForObject:(RLMObject <RestModelObjectProtocol> *)object forType:(RestRequestType)type userInfo:(NSDictionary *)userInfo {

    if(![[object class] respondsToSelector:@selector(primaryKey)] || ![[object class] primaryKey] || ![object valueForKey:[[object class] primaryKey]]){
        [NSException raise:NSInternalInconsistencyException format:@"Class %@ does not have a primary key", [[object class] className]];
    }


    if([object respondsToSelector:@selector(restPathForRequestType:userInfo:)]){
        return [[object restPathForRequestType:type userInfo:userInfo] lowercaseString] ?: [self defaultPathForObject:object];
    }else {
        return [self defaultPathForObject:object];
    }
}

+ (NSString *)defaultPathForObject:(RLMObject <RestModelObjectProtocol> *)object {
    NSString *className = [[[[object class] className] lowercaseString] URLEncode];
    NSString *primaryKey = [[[object valueForKey:[[object class] primaryKey]] lowercaseString] URLEncode];
    return [NSString stringWithFormat:@"%@/%@", className, primaryKey];
}

+ (NSString *)findPathForClass:(Class)class forType:(RestRequestType)type userInfo:(NSDictionary *)userInfo {
    if ([class respondsToSelector:@selector(restPathForRequestType:userInfo:)]){
        return [[(Class <RestModelObjectProtocol>) class restPathForRequestType:type userInfo:userInfo] lowercaseString] ?: [self defaultPathForClass:class];
    } else {
        return [self defaultPathForClass:class];
    }
}

+ (NSString *)defaultPathForClass:(Class)class {
    NSString *className = [[[class className] lowercaseString] URLEncode];
    return [className stringByAppendingString:@"s"];
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
