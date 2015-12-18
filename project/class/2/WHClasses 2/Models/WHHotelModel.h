//
//  WHHotelModel.h
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHHotelModel : NSObject<NSCoding>
@property (nonatomic,copy)NSString * HFHotelAddress;//酒店地址
@property (nonatomic,copy)NSString * HotelName;//酒店名字
@property (nonatomic,copy)NSString * HFHotelPic;//酒店图片
@property (nonatomic,copy)NSString * HFHotelIntro;
@property (nonatomic,assign)int  HFHotelPrice;



//初始化方法
- (instancetype)initWithDict:(NSMutableDictionary *)dict;

//类方法
+ (instancetype)WHCityListModelWithDict:(NSMutableDictionary *)dict;

@end
