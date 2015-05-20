//
// Created by Tobias Sundstrand on 15-01-30.
//

#import <Foundation/Foundation.h>
#import <Realm-Rest/RestOrchestrator.h>
#import <Realm/RLMRealm.h>

@interface RLMRealm (Rest)

@property (nonatomic, readonly) NSString *baseURL;
@property (nonatomic, readonly) RestOrchestrator *orchistrator;

- (void)setBaseUrl:(NSString *)baseUrl queuePersistance:(RestRequestQueuePeristance)peristance;

@end