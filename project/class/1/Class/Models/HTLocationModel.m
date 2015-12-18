//
//  HTLocationModel.m
//  project
//
//  Created by lanou3g on 15/10/31.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTLocationModel.h"

@implementation HTLocationModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"lat"]) {
        _latutide = [NSString stringWithFormat:@"%@",value];
    }
    if ([key isEqualToString:@"lng"]) {
        _longitude = [NSString stringWithFormat:@"%@",value];
    }
}
@end
