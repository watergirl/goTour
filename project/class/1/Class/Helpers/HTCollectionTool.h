//
//  HTCollectionTool.h
//  project
//
//  Created by lanou3g on 15/11/2.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "HTNearbyDataModel.h"
@interface HTCollectionTool : NSObject
@property (nonatomic, strong)FMDatabase * database;
- (void)insertActionWithID:(NSString *)ID name:(NSString *)name introText:(NSString *)introText;
- (NSMutableArray *)queryAction;
- (void)openDb;
- (void)deleteActionWithID:(NSString *)ID;
- (BOOL)queryWithID:(NSString *)ID;
@end
