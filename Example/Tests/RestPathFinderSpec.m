#import "Specta.h"
#import "Cat.h"
#import "Dog.h"
#import "Mouse.h"
#import <Realm-Rest/RestPathFinder.h>

SpecBegin(RestPathFinder)
    __block Cat *cat;
    __block Dog *dog;
    __block Mouse *mouse;
    beforeEach(^{
        cat = [[Cat alloc] init];
        cat.name = @"Misse";

        dog = [[Dog alloc] init];
        dog.name = @"Tom";

        mouse = [[Mouse alloc] init];
        mouse.name = @"Jerry";
    });

    describe(@"RestPathFinder", ^{
        it(@"finds basic get path", ^{
            NSString *path = [RestPathFinder findPathForObject:cat forType:RestRequestTypeGet];
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

        it(@"finds basic get all", ^{
            NSString *path = [RestPathFinder findPathForObject:cat forType:RestRequestTypeGetAll];
            expect(path).to.equal(@"cats");
        });

        it(@"finds custom get all path", ^{
            NSString *path = [RestPathFinder findPathForObject:mouse forType:RestRequestTypeGetAll];
            expect(path).to.equal(@"rest/mouses");
        });

    });

SpecEnd
