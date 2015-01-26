//
// Created by Tobias Sundstrand on 15-01-26.
// Copyright (c) 2015 Tobias Sundstrand. All rights reserved.
//

#import "Mouse.h"


@implementation Mouse

+ (NSString *)restPathToResources {
    return @"rest/mouses";
}

+ (NSString *)primaryKey {
    return @"name";
}

@end