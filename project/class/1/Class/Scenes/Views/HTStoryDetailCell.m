//
//  HTStoryDetailCell.m
//  project
//
//  Created by lanou3g on 15/10/27.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTStoryDetailCell.h"
#import "UIImageView+WebCache.h"
#define HTWIDTH self.window.frame.size.width
#define HTHEIGHT self.window.frame.size.height

#define HTTextFont [UIFont systemFontOfSize:16]



@interface HTStoryDetailCell ()
@property (nonatomic, weak)UIImageView * imgView;


@end
@implementation HTStoryDetailCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //picture
        UIImageView * imgView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:imgView];
        self.imgView = imgView;

        //text
        UILabel *label = [[UILabel alloc] init];
       [self.contentView addSubview:label];
        self.introLabel = label;
        self.contentView.backgroundColor = [UIColor colorWithRed:250 / 255.0  green:245 / 255.0  blue:232 / 255.0 alpha:1];
        self.backgroundColor = [UIColor colorWithRed:250  green:245  blue:232  alpha:1];
        
    }
    return self;
}

- (void)setDetailDataModel:(HTStoryDetailDataModel *)detailDataModel
{
    _detailDataModel = detailDataModel;
     self.introLabel.text = detailDataModel.text;
    [self settingData];
    [self settingFrame];
    
}
- (void)settingData
{
    if (_detailDataModel.imageUrl) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.detailDataModel.imageUrl]];
        self.imgView.hidden = NO;
    } else {
        self.imgView.hidden = YES;
   }
    if (_detailDataModel.text) {
        self.introLabel.text = self.detailDataModel.text;
        self.introLabel.hidden = NO;
    } else {
       self.introLabel.hidden = YES;
    }
    
    
}
- (void)settingFrame
{
    CGFloat padding = 10;
    //setting picture frame
    CGFloat imgViewX = 10.f;
    CGFloat imgViewY = 0.f;
    CGFloat imgViewW = HTWIDTH - 20;
    CGFloat imgViewH = HTWIDTH * 1.f;
    self.imgView.frame = CGRectMake(imgViewX, imgViewY, imgViewW, imgViewH);
    
    
    //setting contentText frame
    CGFloat introLabelX =  20 ;
    CGFloat introLabelY = HTWIDTH * 1.f  + padding;
    CGSize textSize = [[self class]  sizeWithString:_detailDataModel.text font:HTTextFont maxSize:CGSizeMake(HTWIDTH - 40, MAXFLOAT)];
    CGFloat introLabelW = textSize.width;
    CGFloat introLabelH = textSize.height;
    self.introLabel.numberOfLines = 0;
    self.introLabel.frame = CGRectMake(introLabelX, introLabelY, introLabelW, introLabelH);
    self.introLabel.font = HTTextFont;
}

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:dict context:nil].size;

    return size;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self settingFrame];
}

@end
