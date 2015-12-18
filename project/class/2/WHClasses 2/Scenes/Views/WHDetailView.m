//
//  WHDetailView.m
//  project
//
//  Created by lanou3g on 15/10/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "WHDetailView.h"
#import "UIImageView+WebCache.h"
@interface WHDetailView ()
@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *hotelPic;
@property (weak, nonatomic) IBOutlet UILabel *introl;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigh;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end
@implementation WHDetailView

- (void)awakeFromNib {
    
    self.hotelPic.layer.cornerRadius = 8;
    self.hotelPic.layer.masksToBounds = YES;
    self.scroll.showsVerticalScrollIndicator = NO;
}

- (void)setModel:(WHHotelModel *)model
{
    _model = model;
    self.hotelName.text = model.HotelName;
    self.introl.text = model.HFHotelIntro;
    self.price.text = [NSString stringWithFormat:@"价格:%.1f",model.HFHotelPrice];
    [self.hotelPic sd_setImageWithURL:[NSURL URLWithString:model.HFHotelPic]];
    self.address.text = model.HFHotelAddress;

}
- (void)updateConstraints
{
    [super updateConstraints];
  self.height = self.height + self.introl.bounds.size.height + self.address.bounds.size.height;
    
}


@end
