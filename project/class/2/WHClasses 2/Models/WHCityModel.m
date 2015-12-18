//
//  WHCityModel.m
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "WHCityModel.h"

@implementation WHCityModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

//初始化方法
- (instancetype)initWithDict:(NSMutableDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}

//类方法
+ (instancetype)WHCityModelWithDict:(NSMutableDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


@end
