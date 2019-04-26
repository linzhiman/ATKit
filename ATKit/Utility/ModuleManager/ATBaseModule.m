//
//  ATBaseModule.m
//  ATKit
//
//  Created by linzhiman on 2019/4/26.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "ATBaseModule.h"

@implementation ATBaseModule

- (id)init
{
    self = [super init];
    if (self) {
        [self initModule];
    }
    return self;
}

- (void)dealloc
{
    [self uninitModule];
}

- (void)initModule
{
    ;
}

- (void)uninitModule
{
    ;
}

@end
