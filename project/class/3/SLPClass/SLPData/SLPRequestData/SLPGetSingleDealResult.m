//
//  SLPGetSingleDealResult.m
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPGetSingleDealResult.h"
#import "SLPDeal.h"

@implementation SLPGetSingleDealResult

- (NSDictionary *)objectClassInArray
{
    return @{@"deals" : [SLPDeal class]};
}

@end
