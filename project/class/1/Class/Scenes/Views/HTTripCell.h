//
//  HTTripCell.h
//  project
//
//  Created by lanou3g on 15/10/23.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCategoryModel.h"
@class HTTripDataModel;

@interface HTTripCell : UICollectionViewCell
@property (nonatomic, strong)HTTripDataModel * model;
@property (nonatomic, strong)HTCategoryModel * categoryModel;
@end
