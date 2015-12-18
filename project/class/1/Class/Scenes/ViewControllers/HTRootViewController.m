//
//  HTRootViewController.m
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTRootViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HTNearbyTableViewController.h"
#import "RESideMenu.h"
#import "TabBarViewController.h"


@interface HTRootViewController ()<UIScrollViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *rootViewScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong)CLLocation * location;
@property (nonatomic, strong)NSString * currentLat; //当前纬度
@property (nonatomic, strong)NSString * currentLon; //当前经度

@end

@implementation HTRootViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddObsver(toNearbyVC:, @"toNearbyVC")
    
    /**
     此属性默认为YES，这样UIViewController下如果只有一个UIScollView或者其子类，那么会自动留出空白，让scollview滚动经过各种bar下面时能隐约看到内容。但是每个UIViewController只能有唯一一个UIScollView或者其子类，如果超过一个，需要将此属性设置为NO,自己去控制留白以及坐标问题。*/
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.rootViewScrollView.delegate = self;
    self.title = @"旅游";
    self.rootViewScrollView.showsHorizontalScrollIndicator = NO;
    
    //地图
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


- (IBAction)didInlandButtonAction:(UIButton *)sender {
    self.rootViewScrollView.contentOffset = CGPointMake(0, 0);
    self.lineLabel.frame = CGRectMake(0, self.lineLabel.frame.origin.y, self.lineLabel.frame.size.width , self.lineLabel.frame.size.height);
    
    
    
}
- (IBAction)didAbroadButtonAction:(UIButton *)sender {
    
    self.rootViewScrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    self.lineLabel.frame = CGRectMake(self.view.frame.size.width / 2, self.lineLabel.frame.origin.y, self.lineLabel.frame.size.width, self.lineLabel.frame.size.height);
    
}

#pragma mark - scrollerViewDelegate协议方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.lineLabel.frame = CGRectMake(scrollView.contentOffset.x / 2, self.lineLabel.frame.origin.y, self.lineLabel.frame.size.width, self.lineLabel.frame.size.height);
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

//地图
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    self.location = locations.firstObject;
    self.currentLat = [NSString stringWithFormat:@"%f",_location.coordinate.latitude];
    self.currentLon = [NSString stringWithFormat:@"%f",_location.coordinate.longitude];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"nearbySegue"]) {
        HTNearbyTableViewController *nearbyTVC = segue.destinationViewController;
        nearbyTVC.latitude = _currentLat;
        nearbyTVC.longitude = _currentLon;
    }
}



//我的收藏
- (IBAction)didClickCollectionButton:(UIBarButtonItem *)sender {
    
//    [self presentLeftMenuViewController:nil];

    [[TabBarViewController standardTabBarViewController] didReceiveShowMenu];
    
}

- (void)toNearbyVC:(NSNotification *)noti
{

    if ([noti.userInfo[@"type"] isEqualToString:@"nearby"]) {
        [self performSegueWithIdentifier:@"nearbySegue" sender:self];
    }else if ([noti.userInfo[@"type"] isEqualToString:@"story"]){
        [self didAbroadButtonAction:nil];
    }
}

- (void)dealloc
{
    RemoveObsver
}


@end
