//
//  HTStroyDataModel.m
//  project
//
//  Created by lanou3g on 15/10/23.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTStroyDataModel.h"

@implementation HTStroyDataModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _ID = [NSString stringWithFormat:@"%@",value];
    }
    if ([key isEqualToString:@"spot_id"]) {
        _spotID = [NSString stringWithFormat:@"%@",value];
    }
    if ([key isEqualToString:@"text"]) {
        _titleName = value;
    }
    if ([key isEqualToString:@"cover_image_s"]) {
        _imageUrl = value;
    }
    if ([key isEqualToString:@"cover_image_1600"]) {
        _coverImgUrl = value;
    }
    
}



@end
