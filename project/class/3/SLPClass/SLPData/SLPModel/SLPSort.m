
//
//  SLPSort.m
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPSort.h"

@implementation SLPSort

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self encode:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        [self decode:aDecoder];
    }
    return self;
}
@end
