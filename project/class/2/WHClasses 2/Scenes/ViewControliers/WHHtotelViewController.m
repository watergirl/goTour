//
//  WHHtotelViewController.m
//  project
//
//  Created by lanou3g on 15/10/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "WHHtotelViewController.h"
#import "WHCityTableViewController.h"
#import "WHHoellReusableView.h"
#import "WHHotelModel.h"
#import <CoreLocation/CoreLocation.h>
#import "RAMCollectionViewFlemishBondLayout.h"
#import "WHHotelCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "WHCityModel.h"
#import "RESideMenu.h"
#import "HotelViewController.h"
#import "TabBarViewController.h"
@interface WHHtotelViewController ()<WHCityTableViewControllerDelegate,CLLocationManagerDelegate,WHHoellReusableViewDelegate,RAMCollectionViewFlemishBondLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)NSMutableArray * whHotellArray;
@property (nonatomic,assign)int cityId;//城市Id
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,copy)NSString * cityName;
@property (nonatomic,assign)int count;//请求次数（刷新）
@property (nonatomic,strong)CLLocationManager * locationmanager;//位置管理者
@property (nonatomic,assign)int thmid;//酒店类型


@property (nonatomic,strong)NSMutableArray * WHcityListArray;//保存城市列表数组
- (IBAction)collectionButton:(UIBarButtonItem *)sender;

@end
@implementation WHHtotelViewController
static NSString * const reuseIdentifier = @"WHCell";
//懒加载
- (NSMutableArray *)whHotellArray
{
    if (_whHotellArray == nil) {
        _whHotellArray = [NSMutableArray array];
        [self download];
    
    }
    return _whHotellArray;
}
- (NSMutableArray *)WHcityListArray
{
    if (_WHcityListArray == nil) {
        _WHcityListArray = [NSMutableArray array];
        //获取网址对象
        NSURL * url = [NSURL URLWithString:WHCityUrl(self.thmid)];
        NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (data != nil) {
                NSMutableArray * array =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                for ( NSMutableDictionary * dic  in array) {
                    WHCityModel * model = [WHCityModel WHCityModelWithDict:dic];
                    [_WHcityListArray addObject:model];
                }
            }
            [self.collectionView reloadData];
        }];
    }
    return _WHcityListArray;
}

//下载
- (void)download
{
    
    
    NSURL * url = [NSURL URLWithString:WHHotellModelUrl(self.thmid, self.cityId, self.count)];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    
    [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    
    [[NSOperationQueue new] addOperationWithBlock:^{
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data != nil ) {
            NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            for (NSMutableDictionary * dic in array) {
                WHHotelModel * model = [[WHHotelModel alloc] init];
                [model setValuesForKeysWithDictionary: dic];
                [self.whHotellArray addObject:model];
            }
            //回主线程更新视图
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [_collectionView reloadData];
                [MBProgressHUD hideAllHUDsForView:[self currentView] animated:YES];
            }];
        }else{
            [MBProgressHUD hideAllHUDsForView:[self currentView] animated:YES];
        }
    }];
}

- (UIView *)currentView{
    UIViewController *controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    if ([controller isKindOfClass:[UITabBarController class]]) {
        controller = [(UITabBarController *)controller selectedViewController];
    }
    if([controller isKindOfClass:[UINavigationController class]]) {
        controller = [(UINavigationController *)controller visibleViewController];
    }
    if (!controller) {
        return [UIApplication sharedApplication].keyWindow;
    }
    return controller.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //注册cell
    UINib * nib1 = [UINib nibWithNibName:@"WHHotelCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:reuseIdentifier];
    //设置默认值
    self.cityId = 53;
    self.count = 1;
    self.thmid = 45;
    //添加collectionView标题
    [self setUpTitleBar];
    //设置布局方式
    [self setUpcollectionViewLayout];
    
    //开通定位
    [self positioning];
    //选择城市
  //  [self changeCity];
    //下拉刷新,上拉加载
    [self refresh];
    //取消tableView的滚动条
    self.collectionView.showsVerticalScrollIndicator = NO;
   // [self addHotelDetail];
    self.automaticallyAdjustsScrollViewInsets = NO;
       
}

//选择城市
- (void)changeCity
{
    for (WHCityModel * model in _WHcityListArray) {
        if ([self.cityName isEqualToString:model.CityName]) {
            self.cityId = model.CityId;
        }else
        {

            self.cityId = 53;
        }
    }
}

//添加collectionView标题
- (void)setUpTitleBar
{
    WHHoellReusableView * View = [[NSBundle mainBundle] loadNibNamed:@"WHHoellReusableView" owner:nil options:nil].firstObject;
//    CGFloat  heigh =self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
    View.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);

    View.delegate = self;
    [self.view addSubview:View];


}
//设置布局方式
- (void)setUpcollectionViewLayout
{
    //设置区头大小
    RAMCollectionViewFlemishBondLayout * layout = [[RAMCollectionViewFlemishBondLayout alloc] init];
    //设置layout属性
    layout.delegate = self;
    layout.numberOfElements = 3;
    layout.highlightedCellHeight = [UIScreen mainScreen].bounds.size.width*0.65;
    layout.highlightedCellWidth = [UIScreen mainScreen].bounds.size.width*0.65;
    
    self.collectionView.collectionViewLayout = layout;
}

//下拉刷新,上拉加载
- (void)refresh
{
    //下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    }];
    //    上拉加载
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.thmid++;
        [self download];
        
        [self.collectionView.footer endRefreshing];
    }];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
}

//定位
- (void)positioning
{
    //初始化位置管理者
    self.locationmanager = [[CLLocationManager alloc] init];
    //开启定位
    [self.locationmanager startUpdatingLocation];
    //定位授权
    [self.locationmanager requestWhenInUseAuthorization];
    //设置代理
    self.locationmanager.delegate = self;
    
    

}
#pragma mark=====CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation * location = locations.firstObject;
    
    //地理编码
    CLGeocoder * geo = [[CLGeocoder alloc] init];
    [geo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * make = placemarks.firstObject;
        self.cityName = make.name;
        
    }];

}
//cell的点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WHHotelModel * model = _whHotellArray[indexPath.row];
    HotelViewController * VC = [[HotelViewController alloc] initWithNibName:@"HotelViewController" bundle:nil];
    [self.navigationController pushViewController:VC animated:YES];
    [VC view];
   VC.model = model;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//跳转时候执行的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WHCityTableViewController * VC = segue.destinationViewController;
    VC.delegate = self;
}
#pragma mark====WHCityTableViewControllerDelegate协议方法
- (void)sendView:(NSString*)text
{
    //接收传过来的城市Id
    self.cityId = [text intValue];
    self.whHotellArray = nil;
    [self.collectionView reloadData];

}

#pragma mark <UICollectionViewDataSource>
//设置行数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//设置分区数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.whHotellArray.count;
}


//设置cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WHHotelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    WHHotelModel * model =self.whHotellArray[indexPath.row];
    cell.hotelModel = model;
    [cell.hotelPic sd_setImageWithURL:[NSURL URLWithString:model.HFHotelPic]];
    
    return cell;
}


#pragma mark======实现WHHoellReusableViewDelegate
- (void)touchUpInsideChainHotelButton:(UIButton *)button
{
    self.thmid = (int)button.tag;
    self.whHotellArray = nil;
    [self.collectionView reloadData];


}


#pragma mark - RAMCollectionViewVunityLayoutDelegate

- (RAMCollectionViewFlemishBondLayoutGroupDirection)collectionView:(UICollectionView *)collectionView layout:(RAMCollectionViewFlemishBondLayout *)collectionViewLayout highlightedCellDirectionForGroup:(NSInteger)group atIndexPath:(NSIndexPath *)indexPath
{
    RAMCollectionViewFlemishBondLayoutGroupDirection direction;
    
    if (indexPath.row % 2) {
        direction = RAMCollectionViewFlemishBondLayoutGroupDirectionRight;
    } else {
        direction = RAMCollectionViewFlemishBondLayoutGroupDirectionLeft;
    }
    
    return direction;
}


- (IBAction)collectionButton:(UIBarButtonItem *)sender {
    
    
//    [self presentLeftMenuViewController:nil];
    [[TabBarViewController standardTabBarViewController] didReceiveShowMenu];
   
}
@end
