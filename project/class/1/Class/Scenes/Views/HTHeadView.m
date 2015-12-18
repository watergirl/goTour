//
//  HTHeadView.m
//  project
//
//  Created by lanou3g on 15/10/27.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTHeadView.h"
#import "UIImageView+WebCache.h"

@implementation HTHeadView




- (instancetype)initWithFrame:(CGRect)frame imgUrl:(NSString *)imgUrl titleName:(NSString *)titleName titleColor:(UIColor *)color titleFont:(UIFont *)font
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat padding = 10;
        CGFloat WIDTH = frame.size.width;
        CGFloat IMGH = WIDTH * 0.6f;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, IMGH)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        [self addSubview:imgView];
        

        
        UILabel *titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(imgView.frame) + padding, WIDTH, 44)];
        titleNameLabel.text = titleName;
        titleNameLabel.font = [UIFont systemFontOfSize:20];
        titleNameLabel.textColor = color;
        titleNameLabel.textAlignment = NSTextAlignmentCenter;
        titleNameLabel.font = font;
       
        [self addSubview:titleNameLabel];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleNameLabel.frame) + padding, WIDTH  , 1)];
        lineLabel.backgroundColor = [UIColor blackColor];
        [self addSubview:lineLabel];
   
    }
    return self;
}



@end
