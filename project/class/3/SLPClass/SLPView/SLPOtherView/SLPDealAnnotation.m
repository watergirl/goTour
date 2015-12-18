//
//  SLPDealAnnotation.m
//  project
//
//  Created by lanou3g on 15/11/2.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPDealAnnotation.h"

@implementation SLPDealAnnotation
- (BOOL)isEqual:(SLPDealAnnotation *)other
{
    return self.coordinate.latitude == other.coordinate.latitude && self.coordinate.longitude == other.coordinate.longitude;
}
@end
