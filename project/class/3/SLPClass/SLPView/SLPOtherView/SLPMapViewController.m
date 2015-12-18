//
//  SLPMapViewController.m
//  project
//
//  Created by lanou3g on 15/11/2.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPMapViewController.h"
#import <MapKit/MapKit.h>
#import "SLPCategoryName.h"
#import "SLPCategoryView.h"
#import "SLPDealDetailViewController.h"
#import "SLPDeal.h"
#import "SLPBusiness.h"
#import "SLPDealAnnotation.h"
#import "SLPDealAnnoRightButton.h"
#import "SLPFindDealParam.h"
#import "SLPDealTool.h"
@interface SLPMapViewController ()
- (IBAction)backToUserLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) NSString *locationCity;
/**是否正在处理团购信息（是否在请求中 */
@property (nonatomic, assign, getter = isDealingDeals) BOOL dealingDeals;
/** 分类菜单 */
@property (weak, nonatomic) SLPCategoryView *categoryView;
/** 分类button */
@property (strong, nonatomic) UIButton *categoryButton;
/** 当前选中的分类 */
@property (strong, nonatomic) SLPCategoryName *selectedCategory;
@end

@implementation SLPMapViewController
#pragma mark - 懒加载
- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddObsver(backNA, @"goback")
    
    // 设置地图
    [self setupMap];
    
    // 设置导航栏的内容
    [self setupNav];
}
/* 设置地图*/
- (void)setupMap
{
    // 显示用户的位置（一颗发光的蓝色大头针）
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}
/*设置导航栏的内容*/
- (void)setupNav
{
    self.title = @"地图";
    self.selectedCategory = [[SLPMetaDataTool sharedMetaDataTool].categories firstObject];
    // 左边的返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    // 分类菜单
    UIButton *categoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    categoryButton.title = @"分类";
    categoryButton.titleColor = [UIColor blackColor];
    [categoryButton addTarget:self action:@selector(categoryMenuClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryButton];
    self.categoryButton = categoryButton;
    self.navigationItem.leftBarButtonItems = @[backItem,categoryItem];
    // 监听通知
    AddObsver(categoryDidSelect:, CategoryDidSelectNotification);
}
- (void)dealloc
{
    RemoveObsver;
}

- (void)categoryDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.selectedCategory = note.userInfo[SelectedCategory];
    // 设置菜单数据
    // 关闭
    [self.categoryView removeFromSuperview];
    // 清空所有的大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    // 加载最新的数据
    [self mapView:self.mapView regionDidChangeAnimated:YES];
}

#pragma mark - 导航栏左边处理
/** 分类菜单 */
- (void)categoryMenuClick
{
    SLPCategoryView * categoryView = [[SLPCategoryView alloc] init];
    [categoryView showInRect:CGRectMake(30, 64, ScreenW/3, 330)];
    self.categoryView = categoryView;
}
/**返回*/
- (void)back {

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)backNA {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


/**回到用户位置*/
- (IBAction)backToUserLocation {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(SLPDealAnnotation *)annotation
{
    if (![annotation isKindOfClass:[SLPDealAnnotation class]]) return nil;
    
    static NSString *ID = @"deal";
    SLPDealAnnoRightButton *rightBtn = nil;
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        // 显示标题和标题
        annoView.canShowCallout = YES;
        rightBtn = [SLPDealAnnoRightButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightBtn addTarget:self action:@selector(dealClick:)];
        annoView.rightCalloutAccessoryView = rightBtn;
    } else { // annoView是从缓存池取出来
        rightBtn = (SLPDealAnnoRightButton *)annoView.rightCalloutAccessoryView;
    }
    
    // 覆盖模型数据
    annoView.annotation = annotation;
    rightBtn.deal = annotation.deal;
    
    return annoView;
}

- (void)dealClick:(SLPDealAnnoRightButton *)btn
{
    // 弹出详情控制器
    SLPDealDetailViewController *detailVc = [[SLPDealDetailViewController alloc] init];
    detailVc.deal = btn.deal;
    [self.navigationController pushViewController:detailVc animated:YES];
}

/**获取到用户的位置就调用*/
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // 创建区域
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    // 设置地图的显示区域
    [mapView setRegion:region animated:YES];
    
    // 获得城市名称
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0) return;
        
        CLPlacemark *placemark = [placemarks firstObject];
        NSString *city = placemark.addressDictionary[@"State"];
        self.locationCity = [city substringToIndex:city.length - 1];
        
        // 定位到城市，就发送请求
        [self mapView:self.mapView regionDidChangeAnimated:YES];
    }];
}

/**
 *  地图显示的区域发生改变了
 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.locationCity == nil || self.isDealingDeals) return;
    
    self.dealingDeals = YES;
    
    // 1.请求参数
    SLPFindDealParam *param = [[SLPFindDealParam alloc] init];
    // 设置位置信息
    CLLocationCoordinate2D center = mapView.region.center;
    param.latitude = @(center.latitude);
    param.longitude = @(center.longitude);
    param.radius = @5000;
    // 设置城市
    param.city = self.locationCity;
    // 除开“全部分类”和“全部”以外的所有词语都可以发
    // 分类
    if (self.selectedCategory && ![self.selectedCategory.label isEqualToString:@"全部"]){
        param.category = self.selectedCategory.label;
    }else{
        param.category = @"美食";
    }
    
    // 2.发送请求给服务器
    [SLPDealTool findDeals:param success:^(SLPFindDealResult *result) {
        [self setupDeals:result.deals];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"加载团购失败，请稍后再试"];
        
        self.dealingDeals = NO;
    }];
}

/**
 *  处理团购数据
 */
- (void)setupDeals:(NSArray *)deals
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (SLPDeal *deal in deals) {
            for (SLPBusiness *business in deal.businesses) {
                SLPDealAnnotation *anno = [[SLPDealAnnotation alloc] init];
                anno.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
                anno.title = deal.title;
                anno.subtitle = business.name;
                // 设置大头针对应的团购模型
                anno.deal = deal;
                
                // 说明这个大头针已经存在这个数组中（已经显示过了）
                if ([self.mapView.annotations containsObject:anno]) continue;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.mapView addAnnotation:anno];
                });
            }
        }
        
        self.dealingDeals = NO;
    });
}

@end
