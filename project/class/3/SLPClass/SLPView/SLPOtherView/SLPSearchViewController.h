//
//  SLPSearchViewController.h
//  project
//
//  Created by lanou3g on 15/10/28.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLPCity;
@interface SLPSearchViewController : UIViewController
/** 选中的状态 */
@property (nonatomic, strong) SLPCity *selectedCity;
@end
