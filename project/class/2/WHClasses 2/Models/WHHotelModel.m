//
//  WHHotelModel.m
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "WHHotelModel.h"
@implementation WHHotelModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
//实现协议中的两个方法
#pragma mark====进行编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //aCoder编码器
    [aCoder encodeObject:self.HFHotelAddress forKey:@"HFHotelAddress"];
    [aCoder encodeObject:self.HFHotelIntro forKey:@"HFHotelIntro"];
    [aCoder encodeInteger:self.HFHotelPrice forKey:@"HFHotelPrice"];
    [aCoder encodeObject:self.HotelName forKey:@"HotelName"];
    [aCoder encodeObject:self.HFHotelPic forKey:@"HFHotelPic"];
}
#pragma mark====进行反编码
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        //aDecoder反编码器
        self.HFHotelAddress= [aDecoder decodeObjectForKey:@"HFHotelAddress"];
        self.HFHotelIntro = [aDecoder decodeObjectForKey:@"HFHotelIntro"];
        self.HFHotelPrice = [aDecoder decodeIntegerForKey:@"HFHotelPrice"];
        self.HotelName= [aDecoder decodeObjectForKey:@"HotelName"];
        self.HFHotelPic= [aDecoder decodeObjectForKey:@"HFHotelPic"];
    }
    return self;
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
+ (instancetype)WHCityListModelWithDict:(NSMutableDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
