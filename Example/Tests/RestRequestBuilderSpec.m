#import <Realm-Rest/Realm-Rest.h>

SpecBegin(RestRequestBuilder)

    describe(@"RestRequestBuilder", ^{

        context(@"From parameters", ^{

            it(@"Should append path correctly", ^{
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:@"http://api.example.com"]
                                                                             path:@"cats/1312/adsg"
                                                                           method:@"GET"
                                                                       parameters:nil
                                                                          headers:nil];
                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cats/1312/adsg");
            });

            it(@"should handle path with leading /", ^{
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:@"http://api.example.com"]
                                                                             path:@"/cats/1312/adsg"
                                                                           method:@"GET"
                                                                       parameters:nil
                                                                          headers:nil];
                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cats/1312/adsg");
            });

            it(@"should set the correct method/", ^{
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:@"http://api.example.com"]
                                                                             path:@"/cat"
                                                                           method:@"POST"
                                                                       parameters:nil
                                                                          headers:nil];
                expect(urlRequest.HTTPMethod).to.equal(@"POST");
            });

            it(@"should add path parameters for RestRequestParameterStyleURL", ^{
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:@"http://api.example.com"]
                                                                             path:@"/cat"
                                                                           method:@"GET"
                                                                       parameters:@{RestRequestParameterStyleURL: @{@"foo" : @"bar", @"cat" : @"dog"}}
                                                                          headers:nil];
                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cat?cat=dog&foo=bar");
            });

            it(@"should add JSON body parameters for RestRequestParameterStyleJSON", ^{
                NSDictionary *params = @{@"foo" : @"bar", @"cat" : @"dog"};
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:@"http://api.example.com"]
                                                                             path:@"/cat"
                                                                           method:@"POST"
                                                                       parameters:@{RestRequestParameterStyleJSON : params}
                                                                          headers:nil];
                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cat");
                NSDictionary *decoded = [NSJSONSerialization JSONObjectWithData:urlRequest.HTTPBody
                                                                        options:0
                                                                          error:nil];
                expect(decoded).to.equal(params);
            });

            it(@"should add PARAMS body parameters for RestRequesParameterStyleForm", ^{
                NSDictionary *params = @{@"foo" : @"bar", @"cat" : @"dog"};
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithBaseURL:[NSURL URLWithString:@"http://api.example.com"]
                                                                             path:@"/cat"
                                                                           method:@"POST"
                                                                       parameters:@{RestRequestParameterStyleForm: params }
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
                        RESTMethod :@"GET"
                }];
                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cats/1312/adsg");
            });

            it(@"should handle path with leading /", ^{
                NSURLRequest *urlRequest = [RestRequestBuilder requestWithDictionary:@{
                        RESTURL :@"http://api.example.com",
                        RESTPath :@"cats/1312/adsg",
                        RESTMethod :@"GET"
                }];

                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cats/1312/adsg");
            });

            it(@"should set the correct method/", ^{

                NSURLRequest *urlRequest = [RestRequestBuilder requestWithDictionary:@{
                        RESTURL :@"http://api.example.com",
                        RESTPath :@"/cat",
                        RESTMethod :@"POST",
                }];

                expect(urlRequest.HTTPMethod).to.equal(@"POST");
            });

            it(@"should add path parameters for RestRequestBuilderParameterStyleURL", ^{

                NSURLRequest *urlRequest = [RestRequestBuilder requestWithDictionary:@{
                        RESTURL :@"http://api.example.com",
                        RESTPath :@"/cat",
                        RESTMethod :@"GET",
                        RESTParameters :@{RestRequestParameterStyleURL: @{@"foo" : @"bar", @"cat" : @"dog"}}
                }];

                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cat?cat=dog&foo=bar");
            });

            it(@"should add JSON body parameters for RestRequestParameterStyleJSON", ^{
                NSDictionary *params = @{@"foo" : @"bar", @"cat" : @"dog"};

                NSURLRequest *urlRequest = [RestRequestBuilder requestWithDictionary:@{
                        RESTURL :@"http://api.example.com",
                        RESTPath :@"/cat",
                        RESTMethod :@"POST",
                        RESTParameters :@{RestRequestParameterStyleJSON: params }
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
                        RESTParameters : @{RestRequestParameterStyleForm : params}
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
                        RESTHeaders : headers
                }];

                expect(urlRequest.URL.absoluteString).to.equal(@"http://api.example.com/cat");
                expect(urlRequest.allHTTPHeaderFields).to.equal(headers);
            });
        });
    });

SpecEnd
