//
//  SLPSearchViewController.m
//  project
//
//  Created by lanou3g on 15/10/28.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPSearchViewController.h"
#import "SLPFindDealParam.h"
#import "SLPCity.h"
#import "SLPDealTool.h"
#import "MJRefresh.h"
#import "SLPDealListCell.h"
#import "SLPDealDetailViewController.h"
@interface SLPSearchViewController ()<UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,weak)UICollectionView * collectionView;
@property (nonatomic, strong) SLPFindDealParam *lastParam;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak)UIImageView * backView;
/** 存放所有的团购数据 */
@property (nonatomic, strong) NSMutableArray *deals;
@end

@implementation SLPSearchViewController
#pragma mark - 懒加载
- (NSMutableArray *)deals
{
    if (_deals == nil) {
        self.deals = [NSMutableArray array];
    }
    return _deals;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddObsver(back, @"goback")
    
    self.title = @"搜索团购";
    self.view.backgroundColor = SLPColor;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, self.view.frame.size.height-64) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = SLPColor;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, ScreenW, 44)];
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    [self.view addSubview:searchBar];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入关键词";
    self.searchBar = searchBar;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 104, ScreenW, 30)];
    label.backgroundColor = SLPColor;
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    self.label = label;
    // 设置导航栏的内容
    [self setupNav];
    
    // 集成上拉加载更多
    [self setupRefresh];
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"SLPDealListCell" bundle:nil] forCellWithReuseIdentifier:@"SLPDealCell"];
}

/**
 *  集成上拉加载更多
 */
- (void)setupRefresh
{
    //    上拉加载
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreDeals];
        [self.collectionView.footer endRefreshing];
    }];
}

- (void)loadMoreDeals
{
    self.searchBar.userInteractionEnabled = NO;
    
    // 1.创建请求参数
    SLPFindDealParam *param = [[SLPFindDealParam alloc] init];
    // 关键词
    param.keyword = self.searchBar.text;
    // 城市
    param.city = self.selectedCity.name;
    // 页码
    param.page = @(self.lastParam.page.intValue + 1);
    param.category = @"美食";
    // 2.加载数据
    [SLPDealTool findDeals:param success:^(SLPFindDealResult *result) {
        self.totalCount = result.total_count;
        
        // 添加新的数据
        [self.deals addObjectsFromArray:result.deals];
        // 刷新表格
        [self.collectionView reloadData];
        // 结束刷新
        [self.collectionView.footer endRefreshing];
        
        self.searchBar.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
        // 结束刷新
        [self.collectionView.footer endRefreshing];
        // 回滚页码
        param.page = @(param.page.intValue - 1);
        
        self.searchBar.userInteractionEnabled = YES;
    }];
    
    // 3.设置请求参数
    self.lastParam = param;
}

/**
 *  设置导航栏的内容
 */
- (void)setupNav
{
    // 左边的返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
}
/**返回*/
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate
/**点击了搜索按钮*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    
    [MBProgressHUD showMessage:@"正在搜索团购" toView:self.navigationController.view];
    
    // 1.请求参数
    SLPFindDealParam *param = [[SLPFindDealParam alloc] init];
    // 关键词
    param.keyword = searchBar.text;
    // 城市
    param.city = self.selectedCity.name;
    // 页码
    param.page = @1;
    param.category = @"美食";
    // 2.搜索
    [SLPDealTool findDeals:param success:^(SLPFindDealResult *result) {
        self.totalCount = result.total_count;
        [self.deals removeAllObjects];
        [self.deals addObjectsFromArray:result.deals];
        self.label.text = [NSString stringWithFormat:@"共有%d条搜索结果",self.totalCount];
        [self.collectionView reloadData];
        if (self.totalCount == 0) {
            [MBProgressHUD showMessage:@"没有找到相关团购!"];
            [MBProgressHUD hideHUD];
        }
        [MBProgressHUD hideHUDForView:self.navigationController.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
    }];
    
    // 3.赋值
    self.lastParam = param;
   
}


#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectionView.footer.hidden = self.deals.count == self.totalCount;
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
    return CGSizeMake(self.view.width/2, self.view.width*14/45.0+35);
}

#pragma mark - 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 弹出详情控制器
    SLPDealDetailViewController *detailVc = [[SLPDealDetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.item];
    UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:detailVc];
    [self presentViewController:NC animated:YES completion:nil];
}

- (void)dealloc
{
    RemoveObsver
}
@end
