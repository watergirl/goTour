//
//  SLPCity.m
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPCity.h"
#import "SLPRegion.h"

@implementation SLPCity

- (NSDictionary *)objectClassInArray
{
    return @{@"regions" : [SLPRegion class]};
}

@end
