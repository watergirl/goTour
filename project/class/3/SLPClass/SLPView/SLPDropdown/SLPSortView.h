//
//  SLPSortView.h
//  project
//  Created by lanou3g on 15/10/25.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLPSort;


@interface SLPSortView : UIScrollView

/** 当前选中的排序 */
@property (strong, nonatomic) SLPSort *selectedSort;

// 显示菜单
- (void)showInRect:(CGRect)rect;
// 关闭菜单
- (void)dismiss;



@end
