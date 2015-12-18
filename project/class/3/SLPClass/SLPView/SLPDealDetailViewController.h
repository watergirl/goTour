//
//  SLPDealDetailViewController.h
//  project
//
//  Created by lanou3g on 15/10/27.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLPDeal;
@class SLPBusiness;
@interface SLPDealDetailViewController : UIViewController

@property (nonatomic,strong)SLPDeal *deal;
@property (nonatomic,strong)SLPBusiness *business;
@end
