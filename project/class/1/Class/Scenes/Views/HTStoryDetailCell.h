//
//  HTStoryDetailCell.h
//  project
//
//  Created by lanou3g on 15/10/27.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTStoryDetailDataModel.h"



@interface HTStoryDetailCell : UITableViewCell
@property (nonatomic, weak)UILabel * introLabel;
@property (nonatomic, strong)HTStoryDetailDataModel * detailDataModel;
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

@end
