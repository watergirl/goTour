//
//  HTStoryListModel.h
//  project
//
//  Created by lanou3g on 15/10/23.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTStoryListModel : NSObject
@property (nonatomic, assign,getter=isMore)BOOL more;
@property (nonatomic, strong)NSMutableArray * listArray;

@end
