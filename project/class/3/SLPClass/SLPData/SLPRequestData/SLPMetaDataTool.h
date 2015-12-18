//
//  SLPMetaDataTool.h
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SLPCity;
@class SLPSort;
@class SLPDeal;

@interface SLPMetaDataTool : NSObject

+ (instancetype)sharedMetaDataTool;

/**
 *  所有的分类 */
@property (strong, nonatomic, readonly) NSArray *categories;
/**
 *  所有的城市*/
@property (strong, nonatomic, readonly) NSArray *cities;
/**
 *  所有的城市组*/
@property (strong, nonatomic, readonly) NSArray *cityGroups;
/**
 *  所有的排序 */
@property (strong, nonatomic, readonly) NSArray *sorts;

- (SLPCity *)cityWithName:(NSString *)name;

 /*  存储选中的子分类名字*/
- (void)saveSelectedCityName:(NSString *)name;


- (SLPCity *)selectedCity;


/**返回收藏的团购*/
@property (nonatomic, strong, readonly) NSMutableArray *collectDeals;
/*保存收藏的团购*/
- (void)saveCollectDeal:(SLPDeal *)deal;
/**取消收藏的团购*/
- (void)unsaveCollectDeal:(SLPDeal *)deal;
- (void)unsaveCollectDeals:(NSArray *)deals;



@end
