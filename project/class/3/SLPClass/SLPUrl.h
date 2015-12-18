//
//  SLPUrl.h
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#ifndef SLPUrl_h
#define SLPUrl_h


#import "MJExtension.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIView+Extension.h"
#import "UIView+AutoLayout.h"

#import "MBProgressHUD+NJ.h"
#import "SLPMetaDataTool.h"
#import "UIButton+Extension.h"

/** 通知 */
#define SortDidSelectNotification @"SortDidSelectNotification"
#define SelectedSort @"SelectedSort"

#define CityDidSelectNotification @"CityDidSelectNotification"
#define SelectedCity @"SelectedCity"

#define CategoryDidSelectNotification @"CategoryDidSelectNotification"
#define SelectedCategory @"SelectedCategory"

#define RegionDidSelectNotification @"RegionDidSelectNotification"
#define SelectedRegion @"SelectedRegion"
#define SelectedSubRegionName @"SelectedSubRegionName"

#define NotificationCenter [NSNotificationCenter defaultCenter]
#define AddObsver(methodName, noteName) [NotificationCenter addObserver:self selector:@selector(methodName) name:noteName object:nil];
#define RemoveObsver [NotificationCenter removeObserver:self];

#define ScreenW [UIScreen mainScreen].bounds.size.width

#define SLPColor [UIColor colorWithRed:251/255.0 green:247/255.0 blue:237/255.0 alpha:1];
#define SLPTitleColor [UIColor colorWithRed:80/255.0 green:191/255.0 blue:205/255.0 alpha:1];
#endif /* SLPUrl_h */
