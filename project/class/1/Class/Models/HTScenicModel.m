//
//  HTScenicModel.m
//  project
//
//  Created by lanou3g on 15/10/30.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTScenicModel.h"

@implementation HTScenicModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        _introText = value;
    }
    if ([key isEqualToString:@"hottest_places"]) {
        _imageArray = value;
    }
    
}
- (NSMutableArray *)locationArray
{
    if (_locationArray == nil) {
        _locationArray = [NSMutableArray array];
    }
    return _locationArray;
}
@end
