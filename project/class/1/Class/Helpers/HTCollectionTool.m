//
//  HTCollectionTool.m
//  project
//
//  Created by lanou3g on 15/11/2.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTCollectionTool.h"
#import "HTcolldectionModel.h"
#import "MBProgressHUD+NJ.h"

@interface HTCollectionTool ()
@property (nonatomic, strong)NSMutableArray * array; //存放查询结果的数组
@end
@implementation HTCollectionTool
- (void)openDb
{
    NSString * documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString * filePath = [documentPath stringByAppendingPathComponent:@"trip.db"];
//    NSLog(@"%@",filePath);
   //得到数据库
    
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    
    // 3.打开数据库
    if ([db open]) {
        // 4.创表
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_trip (num integer PRIMARY KEY AUTOINCREMENT, ID text NOT NULL , name text NOT NULL , introText TEXT );"];
        if (result) {
//            NSLog(@"成功创表");
        } else {
//            NSLog(@"创表失败");
        }
    }
    
    self.database = db;

}

- (void)insertActionWithID:(NSString *)ID name:(NSString *)name introText:(NSString *)introText
{
    [self openDb];
    if ([self.database open]) {
        
        NSMutableArray *array = [self queryAction];
        for (HTcolldectionModel *model  in array) {
            if ([model.ID isEqualToString:ID]) {
                
//                NSLog(@"已经收藏过了");
                
                [self deleteActionWithID:ID];
                [MBProgressHUD showSuccess:@"取消收藏！"];
                
                [self.database close];
                return;
            }
   
        }
        //数据库中没有收藏过，就收藏
        [self.database executeUpdate:@"INSERT INTO t_trip (ID,name,introText) VALUES (?,?,?);", ID,name,introText];
//        NSLog(@"%@,%@,%@",ID,name,introText);
            }
    [MBProgressHUD showSuccess:@"收藏成功"];
//    NSLog(@"收藏成功");
    [self.database close];
    
}

- (NSMutableArray *)queryAction
{
   
    if ([self.database open]) { //打开成功
        // 1.执行查询语句
        FMResultSet *resultSet = [self.database executeQuery:@"SELECT * FROM t_trip"];
        //遍历结果
        // 2.遍历结果
        while ([resultSet next]) {
            NSString * ID = [resultSet stringForColumn:@"ID"];
            NSInteger num = [resultSet intForColumn:@"num"];
            NSString *name = [resultSet stringForColumn:@"name"];
            NSString *introText = [resultSet stringForColumn:@"introText"];
//            NSLog(@"++++++++++++++%@ %ld", ID, (long)num);
            //赋值给model
            HTcolldectionModel *model = [HTcolldectionModel new];
            model.ID = ID;
            model.name = name;
            model.introText = introText;
            [self.array addObject:model];
        }
    }
    for (NSString *str in _array) {
//        NSLog(@"=======%@",str);

    }
    
       return _array;
    
}

- (BOOL)queryWithID:(NSString *)ID
{
    [self openDb];
    if ([self.database open]) { //打开成功
        // 1.执行查询语句
        FMResultSet *resultSet = [self.database executeQuery:@"SELECT * FROM t_trip WHERE ID = ?",ID];
        //遍历结果
        // 2.遍历结果
        while ([resultSet next]) {
            //有值返回
            [self.database close];
            return YES;
        }
        
    }
    [self.database close];
    //没有查询到
    return NO;
    
}

- (void)deleteActionWithID:(NSString *)ID
{
    
    if ([self.database open]) {
        
       
        //delete from 表名 where 列名 = %@
        [self.database executeUpdateWithFormat:@"delete from t_trip where ID = %@",ID];
        
        [self.database close];
//        [MBProgressHUD showSuccess:@"取消收藏"];
    }
}

- (NSMutableArray *)array
{
    if (_array == nil) {
        _array = [NSMutableArray array];
    }
    return _array;
}
@end
