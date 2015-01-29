//
// Created by Tobias Sundstrand on 15-01-29.
//

#import <Realm-Rest/RestRequestBuilder.h>
#import "RestRequestBuilder.h"
#import "NSURL+QueryDictionary.h"

NSString *const RESTURL = @"url";
NSString *const RESTPath = @"path";
NSString *const RESTMethod = @"method";
NSString *const RESTParameters = @"parameters";
NSString *const RESTParameterStyle = @"parameterStyle";
NSString *const RESTHeaders = @"headers";

@implementation RestRequestBuilder

+ (NSURLRequest *)requestWithBaseURL:(NSURL *)baseURL
                                path:(NSString *)path
                              method:(NSString *)method
                          parameters:(NSDictionary *)params
                      parameterStyle:(RestRequestBuilderParameterStyle)paramStyle
                             headers:(NSDictionary *)headers {

    NSURL *url = [baseURL URLByAppendingPathComponent:path];

    if (paramStyle == RestRequestBuilderParameterStyleURL) {
        url = [url uq_URLByAppendingQueryDictionary:params withSortedKeys:YES];
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = method;

    if (paramStyle == RestRequestBuilderParameterStyleBodyJSON) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params
                                                           options:0
                                                             error:nil];
    }

    if (paramStyle == RestRequestBuilderParameterStyleBodyForm) {
        request.HTTPBody = [[params uq_URLQueryStringWithSortedKeys:YES] dataUsingEncoding:NSUTF8StringEncoding];
    }

    [request setAllHTTPHeaderFields:headers];

    return request;
}

+ (NSURLRequest *)requestWithDictionary:(NSDictionary *)dictionary {

    return [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:dictionary[RESTURL]]
                                             path:dictionary[RESTPath]
                                           method:dictionary[RESTMethod]
                                       parameters:dictionary[RESTParameters]
                                   parameterStyle:(RestRequestBuilderParameterStyle) [dictionary[RESTParameterStyle] integerValue]
                                          headers:dictionary[RESTHeaders]];
}

@end