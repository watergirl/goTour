//
//  WHCityListModel.h
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHCityListModel : NSObject

//城市分类首字母
@property (nonatomic,copy)NSString * Initial;

//城市分组
@property (nonatomic,strong)NSMutableArray * cityList;

//初始化方法
- (instancetype)initWithDict:(NSMutableDictionary *)dict;

//类方法
+ (instancetype)WHCityListModelWithDict:(NSMutableDictionary *)dict;

@end
