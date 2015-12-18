//
//  HTMapViewController.m
//  project
//
//  Created by lanou3g on 15/10/31.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTMapViewController.h"
#import <MapKit/MapKit.h>
@interface HTMapViewController ()<MKMapViewDelegate>
@property (nonatomic, strong)MKMapView * mapView;
@property (nonatomic, strong)MKPointAnnotation * annotation;
@end

@implementation HTMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.mapType = MKMapTypeSatelliteFlyover;
    [self.view addSubview:_mapView];
    //展示用户位置
    self.mapView.showsUserLocation = YES;
    //跟踪模式
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    self.mapView.delegate = self;
    //设置大头针
    CGFloat latitude = [self.latitude doubleValue];
    CGFloat longitude = [self.longitude doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [self setAnnotationWithLocation:location];
    
}

- (void)setAnnotationWithLocation:(CLLocation *)location
{
    //初始化
    self.annotation = [[MKPointAnnotation alloc] init];
    //根据坐标添加大头针
    self.annotation.coordinate = location.coordinate;
   
    //设置
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    [geo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *mark = placemarks.firstObject;
        //设置大头针显示的内容
        self.annotation.title = self.annotationName;
        
    }];
    [self.mapView addAnnotation:self.annotation];
}
@end
