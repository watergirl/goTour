//
//  HTTripCell.m
//  project
//
//  Created by lanou3g on 15/10/23.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTTripCell.h"

#import "UIImageView+WebCache.h"

@interface HTTripCell ()
@property (weak, nonatomic) IBOutlet UILabel *Name_cnLabel;
@property (weak, nonatomic) IBOutlet UILabel *name_enLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
@implementation HTTripCell


#pragma mark - 给HTCategoryModel赋值
- (void)setCategoryModel:(HTCategoryModel *)categoryModel
{
    _categoryModel = categoryModel;
    
    self.Name_cnLabel.text = _categoryModel.name;
    
    self.Name_cnLabel.textColor = [UIColor whiteColor];
    self.name_enLabel.text = _categoryModel.name_en;
    self.name_enLabel.textColor = [UIColor whiteColor];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_categoryModel.cover_s]];
    self.imgView.layer.cornerRadius = 20;
    self.imgView.layer.masksToBounds = YES;
    
    
}
@end
