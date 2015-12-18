//
//  WHHotelCollectionViewController.m
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "WHHotelCollectionViewController.h"
#import "WHCityTableViewController.h"
#import "WHHoellReusableView.h"
#import "WHHotelModel.h"
#import <CoreLocation/CoreLocation.h>
#import "RAMCollectionViewFlemishBondLayout.h"
#import "WHHotelCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
@interface WHHotelCollectionViewController ()<WHCityTableViewControllerDelegate,CLLocationManagerDelegate,WHHoellReusableViewDelegate,RAMCollectionViewFlemishBondLayoutDelegate>
@property (nonatomic,strong)NSMutableArray * whHotellArray;
@property (nonatomic,assign)int cityId;//城市Id

@property (nonatomic,copy)NSString * cityName;

@property (nonatomic,assign)int count;//请求次数（刷新）

@property (nonatomic,strong)CLLocationManager * locationmanager;//位置管理者
@property (nonatomic,assign)int thmid;//酒店类型

@end

@implementation WHHotelCollectionViewController

static NSString * const reuseIdentifier = @"WHCell";

- (NSMutableArray *)whHotellArray
{
    if (_whHotellArray == nil) {
        _whHotellArray = [NSMutableArray array];
       
        [self download];
    }
    return _whHotellArray;
}

- (void)download
{
    
        NSURL * url = [NSURL URLWithString:WHHotellModelUrl(self.thmid, self.cityId, self.count)];
        NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data != nil ) {
            NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            for (NSMutableDictionary * dic in array) {
                WHHotelModel * model = [[WHHotelModel alloc] init];
                [model setValuesForKeysWithDictionary: dic];
                [self.whHotellArray addObject:model];
            }
            [self.collectionView reloadData];
        

    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    //注册cell
    UINib * nib1 = [UINib nibWithNibName:@"WHHotelCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:reuseIdentifier];
    
     //注册区头
    UINib * nib = [UINib nibWithNibName:@"WHHoellReusableView" bundle:nil];
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:RAMCollectionViewFlemishBondHeaderKind withReuseIdentifier:@"WHheader"];
    //设置区头大小
    RAMCollectionViewFlemishBondLayout * layout = [[RAMCollectionViewFlemishBondLayout alloc] init];
    //设置layout属性
    layout.delegate = self;
    layout.numberOfElements = 3;
    layout.highlightedCellHeight = 200.f;
    layout.highlightedCellWidth = 250.f;
    
    
    self.collectionView.collectionViewLayout = layout;
    //开通定位
    [self positioning];
    //设置默认值
    self.cityId = 53;
    self.count = 1;
    self.thmid = 45;
   
    //取消tableView的滚动条
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    }];
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

           self.thmid++;
           [self download];

        
        [self.collectionView.footer endRefreshing];
    }];
    
}
- (void)viewDidAppear:(BOOL)animated
{
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
    NSLog(@"%@",text);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    
    return self.whHotellArray.count;
}

//设置cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WHHotelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    WHHotelModel * model =self.whHotellArray[indexPath.row];
    cell.hotelModel = model;
    NSLog(@"+++++%@",cell.hotelModel.HFHotelPic);
    
    
    [cell.hotelPic sd_setImageWithURL:[NSURL URLWithString:model.HFHotelPic]];
    
    return cell;
}

//设置区头的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == RAMCollectionViewFlemishBondHeaderKind) {
    WHHoellReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WHheader" forIndexPath:indexPath];
    view.delegate = self;
    return view;
    } else
        return 0;
    }
#pragma mark======实现WHHoellReusableViewDelegate
- (void)touchUpInsideChainHotelButton:(UIButton *)button
{
    self.thmid = (int)button.tag;
    self.whHotellArray = nil;
    [self.collectionView reloadData];
}


#pragma mark - RAMCollectionViewVunityLayoutDelegate
//设置区头大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(RAMCollectionViewFlemishBondLayout *)collectionViewLayout estimatedSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
}
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


@end
