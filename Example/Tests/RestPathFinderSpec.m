#import "Cat.h"
#import "Dog.h"
#import "Mouse.h"
#import <Realm-Rest/RLMRealm+Rest.h>
#import <Realm-Rest/RestPathFinder.h>

SpecBegin(RestPathFinder)
    __block Cat *cat;
    __block Dog *dog;
    __block Mouse *mouse;
    __block RLMRealm *realm;
    beforeEach(^{
        cat = [[Cat alloc] init];
        cat.name = @"Misse";

        dog = [[Dog alloc] init];
        dog.name = @"Tom";

        mouse = [[Mouse alloc] init];
        mouse.name = @"Jerry";

        realm = [RLMRealm inMemoryRealmWithIdentifier:@"test"];
        realm.baseURL = @"http://api.example.com";
    });

    describe(@"RestPathFinder", ^{
        context(@"Single object", ^{
            it(@"finds basic get path", ^{
                NSString *path = [RestPathFinder findPathForObject:cat forType:RestRequestTypeGet];
                expect(path).to.equal(@"cat/misse");
            });

            it(@"finds basic post path", ^{
                NSString *path = [RestPathFinder findPathForObject:cat forType:RestRequestTypePost];
                expect(path).to.equal(@"cat/misse");
            });

            it(@"url encodes paths", ^{
                cat.name = @"Misse Miss";
                NSString *path = [RestPathFinder findPathForObject:cat forType:RestRequestTypeGet];
                expect(path).to.equal(@"cat/misse%20miss");
            });

            it(@"fails without primary key", ^{
                expect(^{
                    [RestPathFinder findPathForObject:dog forType:RestRequestTypeGet];
                }).to.raise(NSInternalInconsistencyException);
            });

            it(@"finds custom path", ^{
                NSString *path = [RestPathFinder findPathForObject:mouse forType:RestRequestTypeGet];
                expect(path).to.equal(@"rest/mouse/jerry");
            });

            it(@"finds custom path POST", ^{
                NSString *path = [RestPathFinder findPathForObject:mouse forType:RestRequestTypePost];
                expect(path).to.equal(@"rest/mouse/jerry/create");
            });

            it(@"finds custom path PUT", ^{
                NSString *path = [RestPathFinder findPathForObject:mouse forType:RestRequestTypePut];
                expect(path).to.equal(@"rest/mouse/jerry/update");
            });

            it(@"finds custom path DELETE", ^{
                NSString *path = [RestPathFinder findPathForObject:mouse forType:RestRequestTypeDelete];
                expect(path).to.equal(@"rest/mouse/jerry/remove");
            });

        });

        context(@"Multiple objects", ^{
            it(@"finds basic get all", ^{
                NSString *path = [RestPathFinder findPathForClass:[Cat class] forType:RestRequestTypeGet];
                expect(path).to.equal(@"cats");
            });

            it(@"finds basic post all", ^{
                NSString *path = [RestPathFinder findPathForClass:[Cat class] forType:RestRequestTypePost];
                expect(path).to.equal(@"cats");
            });

            it(@"finds basic put all", ^{
                NSString *path = [RestPathFinder findPathForClass:[Cat class] forType:RestRequestTypePut];
                expect(path).to.equal(@"cats");
            });

            it(@"finds basic delete all", ^{
                NSString *path = [RestPathFinder findPathForClass:[Cat class] forType:RestRequestTypeDelete];
                expect(path).to.equal(@"cats");
            });

            it(@"finds custom get all path", ^{
                NSString *path = [RestPathFinder findPathForClass:[Mouse class] forType:RestRequestTypeGet];
                expect(path).to.equal(@"rest/mouses");
            });

            it(@"finds custom post all path", ^{
                NSString *path = [RestPathFinder findPathForClass:[Mouse class] forType:RestRequestTypePost];
                expect(path).to.equal(@"rest/mouses/create");
            });

            it(@"finds custom put all path", ^{
                NSString *path = [RestPathFinder findPathForClass:[Mouse class] forType:RestRequestTypePut];
                expect(path).to.equal(@"rest/mouses/updates");
            });

            it(@"finds custom delete all path", ^{
                NSString *path = [RestPathFinder findPathForClass:[Mouse class] forType:RestRequestTypeDelete];
                expect(path).to.equal(@"rest/mouses/deletes");
            });


        });

        context(@"Base url", ^{
            it(@"Should find url on realm", ^{
                NSString *baseURL = [RestPathFinder findBaseURLForModelClass:[Cat class] realm:realm];
                expect(baseURL).to.equal(@"http://api.example.com");
            });

            it(@"should find class specific", ^{
                NSString *baseURL = [RestPathFinder findBaseURLForModelClass:[Mouse class] realm:realm];
                expect(baseURL).to.equal(@"http://custom.example.com");
            });

            it(@"Should find it on a new realm instance", ^{
                RLMRealm *realm2 = [RLMRealm inMemoryRealmWithIdentifier:@"test"];
                NSString *baseURL = [RestPathFinder findBaseURLForModelClass:[Cat class] realm:realm2];
                expect(baseURL).to.equal(@"http://api.example.com");
            });

            it(@"Should find it on a the default realm", ^{
                [[RLMRealm defaultRealm] setBaseURL:@"http://api.example.com"];
                NSString *baseURL = [RestPathFinder findBaseURLForModelClass:[Cat class] realm:[RLMRealm defaultRealm]];
                expect(baseURL).to.equal(@"http://api.example.com");
            });

        });

        context(@"HTTP method from request type", ^{
            it(@"GET", ^{
                NSString *method = [RestPathFinder httpMethodFromRequestType:RestRequestTypeGet];
                expect(method).to.equal(@"GET");
            });
            it(@"POST", ^{
                NSString *method = [RestPathFinder httpMethodFromRequestType:RestRequestTypePost];
                expect(method).to.equal(@"POST");
            });
            it(@"PUT", ^{
                NSString *method = [RestPathFinder httpMethodFromRequestType:RestRequestTypePut];
                expect(method).to.equal(@"PUT");
            });
            it(@"DELETE", ^{
                NSString *method = [RestPathFinder httpMethodFromRequestType:RestRequestTypeDelete];
                expect(method).to.equal(@"DELETE");
            });
        });

    });

SpecEnd
