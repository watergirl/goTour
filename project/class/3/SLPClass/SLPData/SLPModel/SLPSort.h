//
//  SLPSort.h
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>


/* 1:默认，2:价格低优先，3:价格高优先，4:购买人数多优先，5:最新发布优先，6:即将结束优先，7:离经纬度坐标距离近优先 */
typedef enum {
    HMSortValueDefault = 1, // 默认排序
    HMSortValueLowPrice, // 价格最低
    HMSortValueHighPrice, // 价格最高
    HMSortValuePopular, // 人气最高
    HMSortValueLatest, // 最新发布
    HMSortValueOver, // 即将结束
    HMSortValueClosest // 离我最近
} HMSortValue;

@interface SLPSort : NSObject<NSCoding>

@property (assign, nonatomic) int value;
@property (copy, nonatomic) NSString *label;

@end
