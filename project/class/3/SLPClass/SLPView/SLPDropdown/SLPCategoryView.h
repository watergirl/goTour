//
//  SLPCategoryView.h
//  project
//
//  Created by lanou3g on 15/10/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLPCategoryName;

@interface SLPCategoryView : UIView

/** 当前选中的分类 */
@property (strong, nonatomic) SLPCategoryName *selectedCategoryName;


// 显示菜单
- (void)showInRect:(CGRect)rect;
// 关闭菜单
- (void)dismiss;

@end
