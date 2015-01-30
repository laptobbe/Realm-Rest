//
// Created by Tobias Sundstrand on 15-01-29.
//

#import <Foundation/Foundation.h>

extern NSString *const RESTURL;
extern NSString *const RESTPath;
extern NSString *const RESTMethod;
extern NSString *const RESTParameters;
extern NSString *const RESTHeaders;
extern NSString *const RESTUserInfo;

extern NSString *const RestRequestParameterStyleURL;
extern NSString *const RestRequestParameterStyleJSON;
extern NSString *const RestRequestParameterStyleForm;

@interface RestRequestBuilder : NSObject

/**
* @params Use the keys: RestRequestParameterStyleURL, RestRequestParameterStyleJSON, RestRequestParameterStyleForm
* with dictionary as values. JSON and Form are mutually exclusive. JSON overrides Form.
*/
+ (NSURLRequest *)requestWithBaseURL:(NSURL *)baseURL
                                path:(NSString *)path
                              method:(NSString *)method
                          parameters:(NSDictionary *)params
                             headers:(NSDictionary *)headers;

+ (NSURLRequest *)requestWithDictionary:(NSDictionary *)dictionary;

@end