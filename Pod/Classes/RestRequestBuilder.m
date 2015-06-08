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
NSString *const RESTHeaders = @"headers";
NSString *const RESTUserInfo = @"userInfo";

NSString *const RestRequestParameterStyleURL = @"url_params";
NSString *const RestRequestParameterStyleJSON = @"json_params";
NSString *const RestRequestParameterStyleForm = @"form_params";

NSString *const RestRequestHeaderContentType = @"Content-Type";

@implementation RestRequestBuilder

+ (NSURLRequest *)requestWithBaseURL:(NSURL *)baseURL
                                path:(NSString *)path
                              method:(NSString *)method
                          parameters:(NSDictionary *)params
                             headers:(NSDictionary *)headers {

    NSURL *url = [baseURL URLByAppendingPathComponent:path];


    NSDictionary *urlParams = params[RestRequestParameterStyleURL];
    if (urlParams) {
        url = [url uq_URLByAppendingQueryDictionary:urlParams withSortedKeys:YES];
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = method;

    NSDictionary *formParams = params[RestRequestParameterStyleForm];
    if (formParams) {
        request.HTTPBody = [[formParams uq_URLQueryStringWithSortedKeys:YES] dataUsingEncoding:NSUTF8StringEncoding];
    }

    NSDictionary *jsonParams = params[RestRequestParameterStyleJSON];
    if (jsonParams) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:jsonParams
                                                           options:0
                                                             error:nil];
    }

    [request setAllHTTPHeaderFields:headers];

    return request;
}

+ (NSURLRequest *)requestWithDictionary:(NSDictionary *)dictionary {

    return [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:dictionary[RESTURL]]
                                             path:dictionary[RESTPath]
                                           method:dictionary[RESTMethod]
                                       parameters:dictionary[RESTParameters]
                                          headers:dictionary[RESTHeaders]];
}

@end