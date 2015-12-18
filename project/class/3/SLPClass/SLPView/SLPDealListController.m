//
//  SLPDealListController.m
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//



#import "SLPDealListController.h"
#import <CoreLocation/CoreLocation.h>
#import "MJRefresh.h"
#import "SLPSort.h"
#import "SLPRegion.h"
#import "SLPCityGroup.h"
#import "SLPCity.h"
#import "SLPCategoryName.h"
#import "SLPUrl.h"
#import "SLPSortView.h"
#import "SLPFindDealParam.h"
#import "SLPDealTool.h"
#import "SLPCategoryView.h"
#import "SLPRegionView.h"
#import "SLPDealListCell.h"
#import "SLPDealDetailViewController.h"
#import "SLPCityViewController.h"
#import "SLPSearchViewController.h"
#import "RAMCollectionViewFlemishBondLayout.h"
#import "UIViewController+RESideMenu.h"
#import "SLPMapViewController.h"
#import "TabBarViewController.h"
@interface SLPDealListController ()<UICollectionViewDataSource,UICollectionViewDelegate,SLPCityViewControllerDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) UIImageView *backView;
/** 顶部菜单 */
@property (weak, nonatomic) UIButton *categoryButton;/** 分类菜单 */
@property (weak, nonatomic) UIButton *regionButton;/** 区域菜单 */
@property (weak, nonatomic) UIButton *sortButton;/** 排序菜单 */

/** 顶部菜单 */
@property (weak, nonatomic) SLPCategoryView *categoryView;/** 分类view */
@property (weak, nonatomic) SLPRegionView *regionView;/** 区域view */
@property (weak, nonatomic) SLPSortView *sortView;/** 排序view */

/** 选中的状态 */
@property (nonatomic, strong) SLPCity *selectedCity;
/** 当前选中的区域 */
@property (strong, nonatomic) SLPRegion *selectedRegion;
/** 当前选中的子区域名称 */
@property (copy, nonatomic) NSString *selectedSubRegionName;
/** 当前选中的排序 */
@property (strong, nonatomic) SLPSort *selectedSort;
/** 当前选中的分类 */
@property (strong, nonatomic) SLPCategoryName *selectedCategoryName;


/** 存放所有的团购数据 */
@property (nonatomic, strong) NSMutableArray *deals;
/*存储请求结果的总数*/
@property (nonatomic, assign) int totalNumber;

// 请求参数
@property (nonatomic, strong)SLPFindDealParam *lastParam;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SLPDealListController



#pragma mark - 懒加载
- (NSMutableArray *)deals
{
    if (_deals == nil) {
        self.deals = [NSMutableArray array];
    }
    return _deals;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    AddObsver(clickSearch, @"clickSearchItem")

    self.title = @"美食";

    self.view.backgroundColor = SLPColor;
    self.selectedCity=[SLPMetaDataTool sharedMetaDataTool].selectedCity;
    // 设置导航栏
    [self setupNav];
    // 设置分类栏
    [self setupButtonView];
    // 设置collectionView
    [self setupCollectionView];
    // 监听通知
    [self setupNotifications];
    // 集成刷新控件
    [self setupRefresh];
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"SLPDealListCell" bundle:nil] forCellWithReuseIdentifier:@"SLPDealCell"];
    [self.collectionView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark - 刷新控件
- (void)setupRefresh
{
    //下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewDeals];
        [self.collectionView.header endRefreshing];
    }];
    //上拉加载
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreDeals];
        [self.collectionView.footer endRefreshing];
    }];
}

#pragma mark - collectionView
- (void)setupCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing=0;
    layout.minimumLineSpacing=0;
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, ScreenW, self.view.height-154) collectionViewLayout:layout];
    collectionView.backgroundColor = SLPColor;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}
#pragma mark - NavigationItem
- (void)setupNav
{
    UIBarButtonItem * mapItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_map"] style:(UIBarButtonItemStylePlain) target:self action:@selector(clickMapItem)];
    UIBarButtonItem * cityItem = [[UIBarButtonItem alloc] initWithTitle:@"城市列表" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickCityItem)];
    mapItem.imageInsets=UIEdgeInsetsMake(5, 5, 5, 5);
    self.navigationItem.rightBarButtonItems= @[cityItem,mapItem];
    
    UIBarButtonItem * collectionItem = [[UIBarButtonItem alloc] initWithTitle:@"我的收藏" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickcollectionItem)];
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"] style:(UIBarButtonItemStylePlain) target:self action:@selector(clickSearchItem)];
    searchItem.imageInsets=UIEdgeInsetsMake(5, 5, 5, 5);
    self.navigationItem.leftBarButtonItems = @[collectionItem,searchItem];
}
#pragma mark - 选择菜单
- (void)setupButtonView
{
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
   // 地区菜单
    UIButton * btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3, 40)];
    [btn1 addTarget:self action:@selector(clickRegionButton) forControlEvents:(UIControlEventTouchUpInside)];
    btn1.backgroundColor = SLPTitleColor;
    [topView addSubview:btn1];
    btn1.title = @"地区";
    self.regionButton = btn1;
    //分类菜单
    UIButton * btn2 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, 0, self.view.frame.size.width/3, 40)];
    [btn2 addTarget:self action:@selector(clickCategoryButton) forControlEvents:(UIControlEventTouchUpInside)];
    btn2.backgroundColor =SLPTitleColor;
    [topView addSubview:btn2];
    btn2.title = @"分类";
    self.categoryButton = btn2;
    //排序菜单
    UIButton * btn3 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3*2, 0, self.view.frame.size.width/3, 40)];
    [btn3 addTarget:self action:@selector(clickSortButton) forControlEvents:(UIControlEventTouchUpInside)];
    btn3.backgroundColor =SLPTitleColor;
    [topView addSubview:btn3];
    btn3.title = @"排序";
    self.sortButton = btn3;
    
    [self.view addSubview:topView];
}
#pragma mark - 点击事件的处理
- (void)clickMapItem
{
    SLPMapViewController *mapVc = [[SLPMapViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mapVc];
    nav.navigationBar.barTintColor = [[UIColor alloc]initWithRed:80/255.0 green:191/255.0 blue:205/255.0 alpha:1.0];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)clickSearchItem
{
    SLPSearchViewController *searchVc = [[SLPSearchViewController alloc] init];
    searchVc.selectedCity = self.selectedCity;
    UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:searchVc];
    NC.navigationBar.barTintColor = [[UIColor alloc]initWithRed:80/255.0 green:191/255.0 blue:205/255.0 alpha:1.0];

    [self presentViewController:NC animated:YES completion:nil];
}
- (void)clickSearch
{
    SLPSearchViewController *searchVc = [[SLPSearchViewController alloc] init];
    searchVc.selectedCity = self.selectedCity;
    UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:searchVc];
    NC.navigationBar.barTintColor = [[UIColor alloc]initWithRed:80/255.0 green:191/255.0 blue:205/255.0 alpha:1.0];
    
    [self presentViewController:NC animated:NO completion:nil];
}

- (void)clickCityItem
{
    SLPCityViewController * VC = [[SLPCityViewController alloc] init];
    VC.delegate = self;
//    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)clickcollectionItem
{
//   [self presentLeftMenuViewController:nil];
    [[TabBarViewController standardTabBarViewController] didReceiveShowMenu];
    
}
- (void)clickRegionButton
{
    SLPRegionView * regionView = [[SLPRegionView alloc] init];
    regionView.regions = self.selectedCity.regions;
    [regionView showInRect:CGRectMake(0, 104, ScreenW/3*2+50, 330)];
    self.regionView = regionView;
}
- (void)clickCategoryButton
{
    SLPCategoryView * categoryView = [[SLPCategoryView alloc] init];
    [categoryView showInRect:CGRectMake(ScreenW/3, 104, ScreenW/3, 330)];
    self.categoryView = categoryView;
}
- (void)clickSortButton
{
    SLPSortView * sortView = [[SLPSortView alloc] init];
    [sortView showInRect:CGRectMake(ScreenW/3*2, 104, ScreenW/3, 330)];
    self.sortView = sortView;
}

#pragma mark - 通知处理
/** 监听通知 */
- (void)setupNotifications
{
    AddObsver(sortDidSelect:, SortDidSelectNotification);
    AddObsver(categoryDidSelect:, CategoryDidSelectNotification);
    AddObsver(regionDidSelect:, RegionDidSelectNotification);
}
- (void)dealloc
{
    RemoveObsver;
}
- (void)regionDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.selectedRegion = note.userInfo[SelectedRegion];
    self.selectedSubRegionName = note.userInfo[SelectedSubRegionName];
    // 关闭
    [self.regionView removeFromSuperview];
    // 加载最新的数据
    [self.collectionView.header beginRefreshing];
}
- (void)categoryDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.selectedCategoryName = note.userInfo[SelectedCategory];
    // 关闭
    [self.categoryView removeFromSuperview];
    // 加载最新的数据
    [self.collectionView.header beginRefreshing];
}
- (void)sortDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.selectedSort = note.userInfo[SelectedSort];
    // 销毁
    [self.sortView removeFromSuperview];
    // 加载最新的数据
    [self.collectionView.header beginRefreshing];
}
#pragma mark - 请求数据
- (SLPFindDealParam *)buildParam
{
    SLPFindDealParam *param= [[SLPFindDealParam alloc] init];
    param.city = self.selectedCity.name;
    // 排序
    if (self.selectedSort) {
        param.sort = @(self.selectedSort.value);
    }
    // 分类
    if (self.selectedCategoryName && ![self.selectedCategoryName.label isEqualToString:@"全部"]){
        param.category = self.selectedCategoryName.label;
    }else{
        param.category = @"美食";
    }
    // 区域
    if (self.selectedRegion && ![self.selectedRegion.name isEqualToString:@"全部"]) {
        if (self.selectedSubRegionName && ![self.selectedSubRegionName isEqualToString:@"全部"]) {
            param.region = self.selectedSubRegionName;
        } else {
            param.region = self.selectedRegion.name;
        }
    }
    return param;
}
#pragma mark - 刷新数据
- (void)loadNewDeals
{
    SLPFindDealParam * param = [self buildParam];
    [SLPDealTool findDeals:param success:^(SLPFindDealResult *result) {
        if (param != self.lastParam) return;
        // 记录总数
        self.totalNumber = result.total_count;
        // 清空之前的所有数据
        [self.deals removeAllObjects];
        // 添加新的数据
        [self.deals addObjectsFromArray:result.deals];
        // 刷新表格
        [self.collectionView reloadData];
        if (self.totalNumber == 0) {
            [MBProgressHUD showMessage:@"没有找到相关团购!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUD];
            });
        }
        [self.collectionView.header endRefreshing];
    } failure:^(NSError *error) {
        if (param != self.lastParam) return;
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
        [self.collectionView.header endRefreshing];
    }];
    // 3.保存请求参数
    self.lastParam = param;
}
- (void)loadMoreDeals
{
    // 1.创建请求参数
    SLPFindDealParam *param = [self buildParam];
    // 页码
    param.page = @(self.lastParam.page.intValue + 1);
    // 2.加载数据
    [SLPDealTool findDeals:param success:^(SLPFindDealResult *result) {
        // 如果请求过期了，直接返回
        if (param != self.lastParam) return;
        // 添加新的数据
        [self.deals addObjectsFromArray:result.deals];
        // 刷新表格
        [self.collectionView reloadData];
        // 结束刷新
        [self.collectionView.footer endRefreshing];
    } failure:^(NSError *error) {
        // 如果请求过期了，直接返回
        if (param != self.lastParam) return;
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
        // 结束刷新
        [self.collectionView.footer endRefreshing];
        // 回滚页码
        param.page = @(param.page.intValue - 1);
    }];
    // 3.设置请求参数
    self.lastParam = param;
}
#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.deals.count == self.totalNumber) {
        self.collectionView.footer.hidden = YES;
    }else{
        self.collectionView.footer.hidden = NO;
    }
    
   return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SLPDealListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SLPDealCell" forIndexPath:indexPath];
    cell.deal = self.deals[indexPath.item];
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.width/2, (self.view.width/2)*28/45.0+35);
}

#pragma mark - 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 弹出详情控制器
    SLPDealDetailViewController *detailVc = [[SLPDealDetailViewController alloc] init];
    detailVc.hidesBottomBarWhenPushed = YES;
    detailVc.deal = self.deals[indexPath.item];
    UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:detailVc];
    NC.navigationBar.barTintColor = [[UIColor alloc]initWithRed:80/255.0 green:191/255.0 blue:205/255.0 alpha:1.0];
    [self presentViewController:NC animated:YES completion:nil];
//    [self.navigationController pushViewController:detailVc animated:YES];
}
// 切换城市代理传值
#pragma mark====SLPCityViewControllerDelegate协议方法
- (void)sendView:(SLPCity*)city
{
    //接收传过来的城市Id
    self.selectedCity = city;
    self.selectedRegion.name = @"全部";
    [[SLPMetaDataTool sharedMetaDataTool] saveSelectedCityName:self.selectedCity.name];
    [self.collectionView.header beginRefreshing];
}



@end

