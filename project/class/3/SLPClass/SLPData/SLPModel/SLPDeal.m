//
//  SLPDeal.m
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPDeal.h"
#import "SLPBusiness.h"
@implementation SLPDeal


- (NSDictionary *)objectClassInArray
{
    return @{@"businesses" : [SLPBusiness class]};
}
- (NSDictionary *)replacedKeyFromPropertyName
{
    // 模型的desc属性对应着字典中的description
    return @{@"desc" : @"description"};
}


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
