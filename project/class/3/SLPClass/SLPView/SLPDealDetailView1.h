//
//  SLPDealDetailView.h
//  project
//
//  Created by lanou3g on 15/10/31.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLPDeal;
@class SLPBusiness;
@interface SLPDealDetailView1 : UIView

@property (nonatomic,strong)SLPDeal *deal;
@property (nonatomic,strong)SLPBusiness *business;

+ (instancetype)menu;
@end
