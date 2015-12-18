//
//  HTScenicModel.h
//  project
//
//  Created by lanou3g on 15/10/30.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTScenicModel : NSObject
@property (nonatomic, strong)NSMutableArray * imageArray; //存放图片的数组
@property (nonatomic, strong)NSString * introText;
@property (nonatomic, strong)NSString * opening_time;
@property (nonatomic, strong)NSString * address;
@property (nonatomic, strong)NSString * arrival_type;
@property (nonatomic, strong)NSString * tel;
@property (nonatomic, strong)NSMutableDictionary * location; //存放位置信息的数组
@property (nonatomic, strong)NSMutableArray * locationArray; //保存位置的数组
@property (nonatomic, strong)NSString * name;
@end
