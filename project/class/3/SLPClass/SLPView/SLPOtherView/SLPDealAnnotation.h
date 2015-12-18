//
//  SLPDealAnnotation.h
//  project
//
//  Created by lanou3g on 15/11/2.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class SLPDeal;
@interface SLPDealAnnotation : NSObject<MKAnnotation>

/**大头针的位置*/
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

/**这颗大头针绑定的团购模型*/
@property (nonatomic, strong) SLPDeal *deal;

@end
