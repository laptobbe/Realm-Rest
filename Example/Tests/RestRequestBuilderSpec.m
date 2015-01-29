#import <Realm-Rest/RestRequestBuilder.h>

SpecBegin(RestRequestBuilder)

    describe(@"RestRequestBuilder", ^{

        context(@"From parameters", ^{

            it(@"Should append path correctly", ^{
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:@"http://api.example.com"]
                                                                             path:@"cats/1312/adsg"
                                                                           method:@"GET"
                                                                       parameters:nil
                                                                   parameterStyle:(RestRequestBuilderParameterStyleURL)
                                                                          headers:nil];
                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cats/1312/adsg");
            });

            it(@"should handle path with leading /", ^{
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:@"http://api.example.com"]
                                                                             path:@"/cats/1312/adsg"
                                                                           method:@"GET"
                                                                       parameters:nil
                                                                   parameterStyle:(RestRequestBuilderParameterStyleURL)
                                                                          headers:nil];
                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cats/1312/adsg");
            });

            it(@"should set the correct method/", ^{
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:@"http://api.example.com"]
                                                                             path:@"/cat"
                                                                           method:@"POST"
                                                                       parameters:nil
                                                                   parameterStyle:(RestRequestBuilderParameterStyleURL)
                                                                          headers:nil];
                expect(urlRequest.HTTPMethod).to.equal(@"POST");
            });

            it(@"should add path parameters for RestRequestBuilderParameterStyleURL", ^{
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:@"http://api.example.com"]
                                                                             path:@"/cat"
                                                                           method:@"GET"
                                                                       parameters:@{@"foo" : @"bar", @"cat" : @"dog"}
                                                                   parameterStyle:(RestRequestBuilderParameterStyleURL)
                                                                          headers:nil];
                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cat?cat=dog&foo=bar");
            });

            it(@"should add JSON body parameters for RestRequestBuilderParameterStyleBodyJSON", ^{
                NSDictionary *params = @{@"foo" : @"bar", @"cat" : @"dog"};
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:@"http://api.example.com"]
                                                                             path:@"/cat"
                                                                           method:@"POST"
                                                                       parameters:params
                                                                   parameterStyle:(RestRequestBuilderParameterStyleBodyJSON)
                                                                          headers:nil];
                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cat");
                NSDictionary *decoded = [NSJSONSerialization JSONObjectWithData:urlRequest.HTTPBody
                                                                        options:0
                                                                          error:nil];
                expect(decoded).to.equal(params);
            });

            it(@"should add PARAMS body parameters for RestRequestBuilderParameterStyleBodyForm", ^{
                NSDictionary *params = @{@"foo" : @"bar", @"cat" : @"dog"};
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:@"http://api.example.com"]
                                                                             path:@"/cat"
                                                                           method:@"POST"
                                                                       parameters:params
                                                                   parameterStyle:(RestRequestBuilderParameterStyleBodyForm)
                                                                          headers:nil];
                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cat");
                NSString *decoded = [[NSString alloc] initWithData:urlRequest.HTTPBody
                                                          encoding:NSUTF8StringEncoding];
                expect(decoded).to.equal(@"cat=dog&foo=bar");
            });

            it(@"should add contain correct headers", ^{
                NSDictionary *headers = @{@"foo" : @"bar", @"cat" : @"dog"};
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:@"http://api.example.com"]
                                                                             path:@"/cat"
                                                                           method:@"POST"
                                                                       parameters:nil
                                                                   parameterStyle:(RestRequestBuilderParameterStyleBodyForm)
                                                                          headers:headers];
                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cat");
                expect(urlRequest.allHTTPHeaderFields).to.equal(headers);
            });
        });

        context(@"From dictionary", ^{
            it(@"Should append path correctly", ^{

                NSURLRequest *urlRequest = [RestRequestBuilder requestWithDictionary:@{
                        RESTURL :@"http://api.example.com",
                        RESTPath :@"cats/1312/adsg",
                        RESTMethod :@"GET",
                        RESTParameterStyle :@(RestRequestBuilderParameterStyleURL)
                }];
                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cats/1312/adsg");
            });

            it(@"should handle path with leading /", ^{
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithDictionary:@{
                        RESTURL :@"http://api.example.com",
                        RESTPath :@"cats/1312/adsg",
                        RESTMethod :@"GET",
                        RESTParameterStyle :@(RestRequestBuilderParameterStyleURL)
                }];

                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cats/1312/adsg");
            });

            it(@"should set the correct method/", ^{

                NSURLRequest *urlRequest = [RestRequestBuilder requestWithDictionary:@{
                        RESTURL :@"http://api.example.com",
                        RESTPath :@"/cat",
                        RESTMethod :@"POST",
                        RESTParameterStyle :@(RestRequestBuilderParameterStyleURL)
                }];

                expect(urlRequest.HTTPMethod).to.equal(@"POST");
            });

            it(@"should add path parameters for RestRequestBuilderParameterStyleURL", ^{

                NSURLRequest *urlRequest = [RestRequestBuilder requestWithDictionary:@{
                        RESTURL :@"http://api.example.com",
                        RESTPath :@"/cat",
                        RESTMethod :@"GET",
                        RESTParameterStyle :@(RestRequestBuilderParameterStyleURL),
                        RESTParameters : @{@"foo" : @"bar", @"cat" : @"dog"}
                }];

                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cat?cat=dog&foo=bar");
            });

            it(@"should add JSON body parameters for RestRequestBuilderParameterStyleBodyJSON", ^{
                NSDictionary *params = @{@"foo" : @"bar", @"cat" : @"dog"};

                NSURLRequest *urlRequest = [RestRequestBuilder requestWithDictionary:@{
                        RESTURL :@"http://api.example.com",
                        RESTPath :@"/cat",
                        RESTMethod :@"POST",
                        RESTParameterStyle :@(RestRequestBuilderParameterStyleBodyJSON),
                        RESTParameters : params
                }];

                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cat");
                NSDictionary *decoded = [NSJSONSerialization JSONObjectWithData:urlRequest.HTTPBody
                                                                        options:0
                                                                          error:nil];
                expect(decoded).to.equal(params);
            });

            it(@"should add PARAMS body parameters for RestRequestBuilderParameterStyleBodyForm", ^{
                NSDictionary *params = @{@"foo" : @"bar", @"cat" : @"dog"};

                NSURLRequest *urlRequest = [RestRequestBuilder requestWithDictionary:@{
                        RESTURL :@"http://api.example.com",
                        RESTPath :@"/cat",
                        RESTMethod :@"POST",
                        RESTParameterStyle :@(RestRequestBuilderParameterStyleBodyForm),
                        RESTParameters : params
                }];

                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cat");
                NSString *decoded = [[NSString alloc] initWithData:urlRequest.HTTPBody
                                                          encoding:NSUTF8StringEncoding];
                expect(decoded).to.equal(@"cat=dog&foo=bar");
            });

            it(@"should add contain correct headers", ^{
                NSDictionary *headers = @{@"foo" : @"bar", @"cat" : @"dog"};

                NSURLRequest *urlRequest = [RestRequestBuilder requestWithDictionary:@{
                        RESTURL :@"http://api.example.com",
                        RESTPath :@"/cat",
                        RESTMethod :@"POST",
                        RESTParameterStyle :@(RestRequestBuilderParameterStyleBodyForm),
                        RESTHeaders : headers
                }];

                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cat");
                expect(urlRequest.allHTTPHeaderFields).to.equal(headers);
            });
        });
    });

SpecEnd
