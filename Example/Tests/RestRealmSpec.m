#import <Realm/Realm/RLMRealm.h>
#import <Realm-Rest/Realm-Rest.h>

SpecBegin(RLMRealm)
    describe(@"Get orchistration", ^{
        it(@"Has an orcistration with the correct queue persistance type", ^{
            [[RLMRealm defaultRealm] setBaseUrl:@"http://examplo.com"
                               queuePersistance:RestRequestQueuePeristanceInMemory];

            expect([[[RLMRealm defaultRealm] orchistrator] peristance]).to.equal(RestRequestQueuePeristanceInMemory);
        });
    });
SpecEnd
