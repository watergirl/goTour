//
//  WHCityModel.h
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHCityModel : NSObject

//城市名字
@property (nonatomic,copy)NSString * CityName;

//城市Id
@property (nonatomic,assign)int CityId;

//城市所属省名字
@property (nonatomic,copy)NSString * ProName;

//初始化方法
- (instancetype)initWithDict:(NSMutableDictionary *)dict;

//类方法
+ (instancetype)WHCityModelWithDict:(NSMutableDictionary *)dict;

@end
