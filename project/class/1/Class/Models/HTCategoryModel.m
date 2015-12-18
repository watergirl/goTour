//
//  CategoryModel.m
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTCategoryModel.h"

@implementation HTCategoryModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _ID = [NSString stringWithFormat:@"%@",value];
    }
    if ([key isEqualToString:@"type"]) {
        _type = [NSString stringWithFormat:@"%@",value];
    }
   
}
@end
