//
//  HTNearbyDataModel.m
//  project
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTNearbyDataModel.h"

@implementation HTNearbyDataModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _ID = [NSString stringWithFormat:@"%@",value];
        
    }
    
    if ([key isEqualToString:@"recommended_reason"]) {
        _recommendText = value;
    }
    
    if ([key isEqualToString:@"distance"]) {
        _distanceText = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"cover_s"]) {
        _coverImage = value;
    }
    if ([key isEqualToString:@"cover_route_map_cover"]) {
        _headImage = value;
    }
    
}
@end
