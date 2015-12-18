//
//  WHHotelCollectionViewCell.m
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "WHHotelCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation WHHotelCollectionViewCell

- (void)awakeFromNib {

    self.hotelPic.layer.cornerRadius = 8;
    self.hotelPic.layer.masksToBounds = YES;
}

- (void)setHotelmodel:(WHHotelModel *)hotelmodel
{
    
    _hotelModel = hotelmodel;
    [self.hotelPic sd_setImageWithURL:[NSURL URLWithString:hotelmodel.HFHotelPic]];
    
    
}

@end
