//
//  HTScenicDatailCell.h
//  project
//
//  Created by lanou3g on 15/10/30.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HTScenicDatailCell : UITableViewCell

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

@property (nonatomic, strong)UILabel * introLabel;
@end
