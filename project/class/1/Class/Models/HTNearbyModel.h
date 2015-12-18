//
//  HTNearbyModel.h
//  project
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTGlobal.h"
@interface HTNearbyModel : NSObject
@property (nonatomic, assign,getter = isMore)BOOL more;
@property (nonatomic, strong)NSMutableArray * items;
HTInitH(nearby);
@end
