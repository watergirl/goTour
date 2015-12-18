//
//  HTScenicDatailCell.m
//  project
//
//  Created by lanou3g on 15/10/30.
//  Copyright © 2015年 lanou3g. All rights reserved.
//


#define HTWIDTH self.window.frame.size.width
#define HTHEIGHT self.window.frame.size.height

#define HTTextFont [UIFont systemFontOfSize:16]


#import "HTScenicDatailCell.h"
#import "HTScenicViewController.h"
@implementation HTScenicDatailCell


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self settingFrame];
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createChlid];
    }
    
    return self;
    
    
}

-(void)createChlid{
    
    self.introLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.introLabel];
    self.introLabel.font = [UIFont systemFontOfSize:16];
    self.introLabel.numberOfLines = 0;
       
}

- (void)settingFrame
{
    
    //setting contentText frame
    CGFloat introLabelX =  10.f;
    CGFloat introLabelY =  10.f;
    CGSize textSize = [[self class]  sizeWithString:_introLabel.text font:HTTextFont maxSize:CGSizeMake(HTWIDTH - 20, MAXFLOAT)];
    CGFloat introLabelW = textSize.width;
    CGFloat introLabelH = textSize.height;


    self.introLabel.frame = CGRectMake(introLabelX, introLabelY, introLabelW, introLabelH);
    self.introLabel.font = HTTextFont;
    

}



+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:dict context:nil].size;
    
    return size;
}


@end
