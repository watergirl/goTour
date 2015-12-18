//
//  HTStoryDetailDataModel.m
//  project
//
//  Created by lanou3g on 15/10/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTStoryDetailDataModel.h"

@implementation HTStoryDetailDataModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"photo_w640"]) {
        _imageUrl = value;
    }
}
@end
