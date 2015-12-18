//
//  WHCityTableViewCell.m
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "WHCityTableViewCell.h"
#import "WHCityModel.h"
@implementation WHCityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setWhCityModel:(WHCityModel *)whCityModel
{
    _whCityModel = whCityModel;
    self.cityName = whCityModel.CityName;
    self.proName = whCityModel.ProName;
    
}


@end
