//
//  SLPCityViewController.h
//  project
//
//  Created by lanou3g on 15/11/2.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLPCity;
@protocol SLPCityViewControllerDelegate <NSObject>

- (void)sendView:(SLPCity*)city;

@end

@interface SLPCityViewController : UIViewController

@property (nonatomic,assign)id<SLPCityViewControllerDelegate>delegate;

@end
