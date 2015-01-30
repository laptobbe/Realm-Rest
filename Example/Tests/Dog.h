//
// Created by Tobias Sundstrand on 15-01-26.
// Copyright (c) 2015 Tobias Sundstrand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm-Rest/RestModelObjectProtocol.h>
#import "Realm.h"
#import "RLMObject.h"

@interface Dog : RLMObject

@property NSString *name;

@end