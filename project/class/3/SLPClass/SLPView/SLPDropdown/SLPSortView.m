//
//  SLPSortView.m
//  project
//
//  Created by lanou3g on 15/10/25.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPSortView.h"
#import "SLPSort.h"
#import "UIButton+Extension.h"


@interface SLPSortView ()
@property(nonatomic,strong)UIScrollView *contentView; // 菜单中的内容
@property(nonatomic,strong)UIButton * cover; // 点击回收

@property (nonatomic, strong)UIButton * selectedButton;


@end

@implementation SLPSortView

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 添加遮盖按钮
        self.cover = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.cover addTarget:self action:@selector(coverClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.cover];
        // 添加菜单
        self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW/3, self.frame.size.height/2)];
        self.contentView.userInteractionEnabled = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
   
        [self addView];
    }
    return self;
}

- (void)addView
{
    // 根据排序模型的个数，创建对应的按钮
    CGFloat buttonX = 0;
    CGFloat buttonW = self.contentView.width;
    CGFloat buttonP = 15;
    NSArray *sorts = [SLPMetaDataTool sharedMetaDataTool].sorts;
    CGFloat contentH = 0;
    for (int i = 0; i<sorts.count; i++) {
        // 创建按钮
        UIButton *button = [[UIButton alloc] init];
        button.bgImage = @"btn_filter_normal";
        button.selectedBgImage = @"btn_filter_selected";
        button.titleColor = [UIColor blackColor];
        button.selectedTitleColor = [UIColor whiteColor];
        // 取出模型
        SLPSort * sort = sorts[i];
        button.title = sort.label;
        // 设置尺寸
        button.x = buttonX;
        button.width = buttonW;
        button.height = 30;
        button.y = buttonP + i * (button.height + buttonP);
        // 监听按钮点击
        [button addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:button];
        
        // 内容的高度
        contentH = button.maxY + buttonP;
    }
    // 设置contentSize

    self.contentView.contentSize = CGSizeMake(0, contentH);

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cover.frame = self.bounds;
}

// 内部方法
- (void)coverClick
{
    [self dismiss];
}
// 显示菜单
- (void)showInRect:(CGRect)rect
{
    // 添加菜单到整体的窗口上
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    
    // 设置容器的frame
    self.contentView.frame = rect;
}
// 关闭菜单
- (void)dismiss
{
    [self removeFromSuperview];
}
- (void)sortButtonClick:(UIButton *)button
{
    // 1.修改状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    [self removeFromSuperview];
    // 2.发出通知
    NSArray * sorts = [[SLPMetaDataTool sharedMetaDataTool] sorts];
    for (SLPSort * sort in sorts) {
        if ([sort.label isEqualToString:button.title]) {
            self.selectedSort = sort;
        }
    }
    [NotificationCenter postNotificationName:SortDidSelectNotification object:nil userInfo:@{SelectedSort :self.selectedSort}];
}

- (void)setSelectedSort:(SLPSort *)selectedSort
{
    _selectedSort = selectedSort;
    
    for (UIButton *button in self.contentView.subviews) {
        if ([button isKindOfClass:[UIButton class]] && button.title== selectedSort.label) {
            self.selectedButton.selected = NO;
            button.selected = YES;
            self.selectedButton = button;
        }
    }
}





@end
