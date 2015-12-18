//
//  HotelToll.h
//  project
//
//  Created by lanou3g on 15/11/2.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHHotelModel.h"
@interface HotelToll : NSObject
- (NSMutableArray *)queryHotel;
- (void)collectHotel:(WHHotelModel *)model;
- (void)removeHotel:(WHHotelModel *)model;
- (void)insertActionWithModel:(WHHotelModel *)model;
- (BOOL)queryWithModel:(WHHotelModel *)model;
@end
