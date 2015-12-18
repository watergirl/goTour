//
//  HTNearbyCell.m
//  project
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTNearbyCell.h"
#import "UIImageView+WebCache.h"
@implementation HTNearbyCell

- (void)setDataModel:(HTNearbyDataModel *)dataModel
{
    _dataModel = dataModel;
    
    self.nameLabel.text = _dataModel.name;
    self.descriptionLabel.text = _dataModel.recommendText;
    self.descriptionLabel.font = [UIFont systemFontOfSize:16];
    NSString *distanceStr = [_dataModel.distanceText substringToIndex:4];
    self.distanceLabel.text = distanceStr;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_dataModel.coverImage]];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:dict context:nil].size;
    
    return size;
}

@end
