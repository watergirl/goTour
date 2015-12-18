//
//  HTStoryDetailModel.m
//  project
//
//  Created by lanou3g on 15/10/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTStoryDetailModel.h"

@implementation HTStoryDetailModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"cover_image_w640"]) {
        _imageUrl = value;
    }
    if ([key isEqualToString:@"detail_list"]) {
        _details = value;
    }
}
@end
