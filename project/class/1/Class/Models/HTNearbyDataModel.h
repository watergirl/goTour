//
//  HTNearbyDataModel.h
//  project
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTNearbyDataModel : NSObject
@property (nonatomic, strong)NSString * name;
@property (nonatomic, strong)NSString * recommendText; //推荐简介
@property (nonatomic, strong)NSString * distanceText;
@property (nonatomic, strong)NSString * ID;
@property (nonatomic, strong)NSString * coverImage;
@property (nonatomic, strong)NSString * headImage;
@end
