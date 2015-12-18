//
//  SLPRegionView.m
//  project
//
//  Created by lanou3g on 15/10/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPRegionView.h"
#import "SLPRegion.h"
#import "SLPRegionMainCell.h"
#import "SLPRegionSubCell.h"
#import "SLPCity.h"
#import "SLPDealDetailViewController.h"

@interface SLPRegionView ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView *contentView; // 菜单中的内容
@property(nonatomic,strong)UIButton * cover; // 点击回收

@property (strong, nonatomic)UITableView *mainTableView; //
@property (strong, nonatomic)UITableView *subTableView; //

@property (nonatomic, strong) UIImageView *rightArrow;
@end


@implementation SLPRegionView

//- (UIImageView *)rightArrow
//{
//    if (_rightArrow == nil) {
//        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
//    }
//    return _rightArrow;
//}

- (void)setRegions:(NSArray *)regions
{
    _regions = regions;
    [self.mainTableView reloadData];
    [self.subTableView reloadData];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 添加遮盖按钮
        self.cover = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.cover addTarget:self action:@selector(coverClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.cover];
        // 添加菜单
        self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW/3*2, self.frame.size.height/2)];
        self.contentView.userInteractionEnabled = YES;
        [self addSubview:self.contentView];
        
        
        CGFloat Width = self.contentView.frame.size.width;
        CGFloat Height = self.contentView.frame.size.height;
        
        self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width/2, Height-35) style:(UITableViewStylePlain)];
        self.mainTableView.delegate = self;
        self.mainTableView.dataSource = self;
        [self.contentView addSubview:self.mainTableView];
        
        
        self.subTableView = [[UITableView alloc] initWithFrame:CGRectMake(Width/2, 0, Width/2, Height-35) style:(UITableViewStylePlain)];
        self.subTableView.delegate = self;
        self.subTableView.dataSource = self;
        self.subTableView.backgroundColor = [UIColor clearColor];
        self.subTableView.separatorColor = [UIColor clearColor];
        [self.contentView addSubview:self.subTableView];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cover.frame = self.bounds;
    // 刷新表格
    [self.mainTableView reloadData];
    [self.subTableView reloadData];

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
- (void)willMoveToWindow:(UIWindow *)newWindow
{
    self.mainTableView.frame = CGRectMake(0, 0, ScreenW/3, 330);
    self.subTableView.frame = CGRectMake(ScreenW/3, 0, ScreenW/3+50, 330);
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView == self.mainTableView) {
        return _regions.count;
    }
    if(tableView == self.subTableView){
        // 得到mainTableView选中的行
        int mainRow = [self.mainTableView indexPathForSelectedRow].row;
        if (mainRow >0) {
            SLPRegion * region = _regions[mainRow];
            return [region subregions].count;
        }

    }
    return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {  // 左边主表的cell
        SLPRegionMainCell * mainCell = [SLPRegionMainCell cellWithTableView:tableView];
        mainCell.textLabel.text = [_regions[indexPath.row] name];
        if ([_regions[indexPath.row] subregions].count > 0) {
            mainCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
        } else {
            mainCell.accessoryView = nil;
        }
        return mainCell;
    } else { // 右边主表的cell
        SLPRegionSubCell * subCell = [SLPRegionSubCell cellWithTableView:tableView];
        // 得到mainTableView选中的行
        int mainRow = [self.mainTableView indexPathForSelectedRow].row;
        SLPRegion * region = _regions[mainRow];
        subCell.textLabel.text = [region subregions][indexPath.row];
        return subCell;
    }
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) { // 左边的主表
        // 刷新右边
        [self.subTableView reloadData];
        int mainRow = [self.mainTableView indexPathForSelectedRow].row;
        SLPRegion * region = _regions[mainRow];
        if (region.subregions.count == 0) {
            [NotificationCenter postNotificationName:RegionDidSelectNotification object:nil userInfo:@{SelectedRegion : region}];
        }
    }else{ // 右边的从表
            // 发出通知，选中了某个分类
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            int mainRow = [self.mainTableView indexPathForSelectedRow].row;
            int subRow = [self.subTableView indexPathForSelectedRow].row;
            SLPRegion * region = _regions[mainRow];
            userInfo[SelectedRegion] = region;
            userInfo[SelectedSubRegionName] = region.subregions[subRow];
            [NotificationCenter postNotificationName:RegionDidSelectNotification object:nil userInfo:userInfo];
        }
    
}


@end
