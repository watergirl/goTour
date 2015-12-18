//
//  WHHotelCollectionViewCell.h
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHHotelModel.h"
@interface WHHotelCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *hotelPic;
@property (nonatomic,strong)WHHotelModel * hotelModel;


@end
