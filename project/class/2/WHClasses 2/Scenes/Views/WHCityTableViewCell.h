//
//  WHCityTableViewCell.h
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHCityModel;
@interface WHCityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *city;

@property (nonatomic,copy)NSString * cityName;
@property (nonatomic,copy)NSString * proName;

@property (nonatomic,copy)NSString * cityId;

@property (nonatomic,strong)WHCityModel * whCityModel;
@end
