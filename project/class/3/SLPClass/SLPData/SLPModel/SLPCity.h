//
//  SLPCity.h
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLPCity : NSObject

/** 城市名称 */
@property (copy, nonatomic) NSString *name;
/** 区域 */
@property (strong, nonatomic) NSArray *regions;
/** 拼音 beijing */
@property (copy, nonatomic) NSString *pinYin;
/** 拼音首字母 bj */
@property (copy, nonatomic) NSString *pinYinHead;

@end
