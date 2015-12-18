//
//  SLPDealListCell.m
//  project
//
//  Created by lanou3g on 15/10/27.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPDealListCell.h"
#import "SLPDeal.h"
#import "UIImageView+WebCache.h"
@interface SLPDealListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@end

@implementation SLPDealListCell
- (void)setDeal:(SLPDeal *)deal
{
    _deal = deal;
    self.imgView.layer.cornerRadius = 10;
    self.imgView.layer.masksToBounds = YES;
    // 图片
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"0"]];
    // 标题
    self.titleLabel.text = deal.title;
    
}


@end
