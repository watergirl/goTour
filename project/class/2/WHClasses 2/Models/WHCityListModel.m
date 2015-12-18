//
//  WHCityListModel.m
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "WHCityListModel.h"
#import "WHCityModel.h"
@implementation WHCityListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@属性不存在",key);
}

//初始化方法
- (instancetype)initWithDict:(NSMutableDictionary *)dict
{
    if (self = [super init]) {
        
        self.Initial = dict[@"Initial"];
        NSMutableArray * array = dict[@"cityList"];
        NSMutableArray * cityList = [NSMutableArray array];
        for (NSMutableDictionary * dic in array) {
            WHCityModel * model = [WHCityModel WHCityModelWithDict:dic];
            [cityList addObject:model];
        }
        self.cityList = cityList;
        
    }
    return self;
}

//类方法
+ (instancetype)WHCityListModelWithDict:(NSMutableDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
