//
//  HTStoryListModel.m
//  project
//
//  Created by lanou3g on 15/10/23.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTStoryListModel.h"
#import "HTStroyDataModel.h"
@implementation HTStoryListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"hot_spot_list"]) {
        self.listArray = value;
    }
}



@end
