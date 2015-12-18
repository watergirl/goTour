//
//  SLPCityGroup.h
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLPCityGroup : NSObject

/** 组标题 */
@property (copy, nonatomic) NSString *title;
/** 这组显示的城市 */
@property (strong, nonatomic) NSArray *cities;

@end
