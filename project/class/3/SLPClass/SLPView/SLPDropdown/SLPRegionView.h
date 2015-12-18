//
//  SLPRegionView.h
//  project
//
//  Created by lanou3g on 15/10/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLPCity;
@class SLPRegion;

@interface SLPRegionView : UIView



@property (nonatomic, strong) NSArray *regions;



// 显示菜单
- (void)showInRect:(CGRect)rect;
// 关闭菜单
- (void)dismiss;

@end
