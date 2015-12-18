//
//  HotelToll.m
//  project
//
//  Created by lanou3g on 15/11/2.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HotelToll.h"
#import <sqlite3.h>


@interface HotelToll()
{
    sqlite3 * _db;
}
@end
@implementation HotelToll


- (void)openHoel
{
    //1.获取沙盒中Document这个文件夹的路径
    NSString * documentsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    //1.拼接存储路径
    NSString * hotelPath = [documentsPath stringByAppendingPathComponent:@"hotelModel.db"];
    //打开数据库
    sqlite3_open(hotelPath.UTF8String, &_db);
    NSString * createSql = @"CREATE TABLE hotelModels (HotelName TEXT, HFHotelPrice INTEGER, HFHotelPic TEXT, HFHotelIntro TEXT, HFHotelAddress TEXT PRIMARY KEY);";
    //2.执行SQL语句，打开数据库表
    char * errmsq = NULL;
    sqlite3_exec(_db, createSql.UTF8String, NULL, NULL, &errmsq);
   
}
- (void)collectHotel:(WHHotelModel *)model
{
    [self openHoel];
     sqlite3_stmt * stmt = NULL;
    //添加对象
    NSString * insertSql = @"insert into hotelModels(HotelName,HFHotelPrice,HFHotelPic,HFHotelIntro,HFHotelAddress) values(?,?,?,?,?)";
    // sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(_db, insertSql.UTF8String, -1, &stmt, NULL);
  
    sqlite3_bind_text(stmt, 1, [model.HotelName UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [model.HFHotelPic UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [model.HFHotelIntro UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 5, [model.HFHotelAddress UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 2, model.HFHotelPrice);
    sqlite3_step(stmt);
    
    
    
    sqlite3_finalize(stmt);
    sqlite3_close(_db);
    _db = NULL;
}
- (NSMutableArray *)queryHotel
{
    NSMutableArray * array = [NSMutableArray array];
    
    [self openHoel];
    sqlite3_stmt * stmt = NULL;

    //1.准备SQL语句(查询)
    //形式: select * from 表名
    NSString * sql = @"select * from hotelModels";
    //检查SQL语句是否合法
    //跟随指针
    int result = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {//表示查找到了一条正确数据
            //取字段下的值
            //            sqlite3_column_xxx方法中的第二个参数与数据库表中的字段的顺序是一致的。(下标从0开始)
            NSString * HotelName = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 0)];
            int HFHotelPrice = sqlite3_column_int(stmt, 1);
            NSString * HFHotelPic= [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 2)];
            NSString * HFHotelIntro= [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 3)];
            NSString * HFHotelAddress= [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt,4)];
            WHHotelModel * model = [[WHHotelModel alloc] init];
            model.HotelName = HotelName;
            model.HFHotelPrice = HFHotelPrice;
            model.HFHotelPic = HFHotelPic;
            model.HFHotelIntro = HFHotelIntro;
            model.HFHotelAddress = HFHotelAddress;
            
            [array addObject:model];
        }
        
    }
    sqlite3_finalize(stmt);
    sqlite3_close(_db);
    _db = NULL;
    return array;
    
}
- (void)removeHotel:(WHHotelModel *)model
{
    [self openHoel];
    NSString * deleteSql = @"delete from hotelModels where HotelName = ?";
    //2，检查SQL是否合法
    sqlite3_stmt * stmt = NULL;
    int result= sqlite3_prepare_v2(_db, deleteSql.UTF8String, -1, &stmt, NULL);
    if (result==SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, model.HotelName.UTF8String, -1, NULL);
        sqlite3_step(stmt);
        
    }

    sqlite3_finalize(stmt);
    sqlite3_close(_db);
    _db = NULL;

    
}

- (void)insertActionWithModel:(WHHotelModel *)model
{
    [self openHoel];
    
    NSMutableArray *array = [self queryHotel];
    for (WHHotelModel *m  in array) {
        if ([m.HFHotelAddress isEqualToString:model.HFHotelAddress]) {
            
//            NSLog(@"已经收藏过了");
            
            [self removeHotel:model];
            [MBProgressHUD showSuccess:@"取消收藏！"];
            
            sqlite3_close(_db);
            return;
        }
    }
        //数据库中没有收藏过，就收藏
    [self collectHotel:model];
    [MBProgressHUD showSuccess:@"收藏成功"];
//    NSLog(@"收藏成功");
    sqlite3_close(_db);
}

- (BOOL)queryWithModel:(WHHotelModel *)model
{
    [self openHoel];
    sqlite3_stmt * stmt = NULL;
    // 1. 准备SQL语句
    NSString *sql = @"SELECT * FROM hotelModels WHERE HFHotelAddress = ?";
    int result = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    sqlite3_bind_text(stmt, 1, [model.HFHotelAddress UTF8String], -1, NULL);
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {//表示查找到了一条正确数据
            sqlite3_finalize(stmt);
            sqlite3_close(_db);
            _db = NULL;
            return YES;
        }
//        sqlite3_close(_db);
//        //没有查询到
//        return NO;
    }
    sqlite3_finalize(stmt);
    sqlite3_close(_db);
    _db = NULL;
    //没有查询到
    return NO;
    
}


@end
