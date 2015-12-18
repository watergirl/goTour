//
//  SLPDealDetailView.m
//  project
//
//  Created by lanou3g on 15/10/31.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPDealDetailView1.h"
#import "SLPBusiness.h"
#import "SLPDeal.h"
#import "SLPRestriction.h"
@interface SLPDealDetailView1 ()
// 按钮
@property (weak, nonatomic) IBOutlet UIButton *refundableAnyTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *refundableExpiresButton;
@property (weak, nonatomic) IBOutlet UIButton *leftTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseCountButton;
@property (weak, nonatomic) IBOutlet UIButton *reservationButton;

@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessLabel;// 适用商户
@property (weak, nonatomic) IBOutlet UILabel *businessAddressLabel;
@end
@implementation SLPDealDetailView1

+ (instancetype)menu
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SLPDealDetailView1" owner:nil options:nil] firstObject];
    
}

- (void)setDeal:(SLPDeal *)deal
{
    _deal = deal;
    // 简单信息
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f", self.deal.current_price];
    self.listPriceLabel.text = [NSString stringWithFormat:@"门店价￥%0.2f", self.deal.list_price];
    // 剩余时间处理
    // 当前时间 2014-08-27 09:06
    NSDate *now = [NSDate date];
    // 过期时间 2014-08-28 00:00
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *deadTime = [[fmt dateFromString:self.deal.purchase_deadline] dateByAddingTimeInterval:24 * 3600];
    // 比较2个时间的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmps = [calendar components:unit fromDate:now toDate:deadTime options:0];
    if (cmps.day > 365) {
        self.leftTimeButton.title = @"一年内不过期";
    } else {
        self.leftTimeButton.title = [NSString stringWithFormat:@"%ld天%ld小时%ld分", (long)cmps.day, (long)cmps.hour, (long)cmps.minute];
    }
    //button
    self.refundableAnyTimeButton.selected = self.deal.restrictions.is_refundable;
    self.refundableExpiresButton.selected = self.deal.restrictions.is_refundable;
    self.reservationButton.selected = !self.deal.restrictions.is_reservation_required;
    self.purchaseCountButton.title = [NSString stringWithFormat:@"已售出%0.f", self.deal.purchase_count];
    // 商户信息
    self.business = [self.deal.businesses firstObject];
    self.businessLabel.text = self.business.name;
    self.businessAddressLabel.text = self.business.address;
}





@end
