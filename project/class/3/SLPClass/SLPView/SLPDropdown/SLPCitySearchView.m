
//
//  SLPCitySearchView.m
//  project
//
//  Created by lanou3g on 15/10/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPCitySearchView.h"
#import "SLPCity.h"

@interface SLPCitySearchView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *resultCities;
@end

@implementation SLPCitySearchView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = SLPColor;
    }
    return self;
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = [searchText copy];
    
    // 根据搜索条件进行过滤
    NSArray *allCities = [SLPMetaDataTool sharedMetaDataTool].cities;
    
    // 将搜索条件转为小写
    NSString *lowerSearchText = searchText.lowercaseString;
    
    //    NSPredicate * 预言\过滤器\谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name.lowercaseString contains %@ or pinYin.lowercaseString contains %@ or pinYinHead.lowercaseString contains %@", lowerSearchText, lowerSearchText, lowerSearchText];
    self.resultCities = [allCities filteredArrayUsingPredicate:predicate];
    
    [self reloadData];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    SLPCity *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}

#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%lu个搜索结果", (unsigned long)self.resultCities.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.关闭控制器
    [self removeFromSuperview];
    
    // 2.发出通知
    SLPCity *selectedCity = self.resultCities[indexPath.row];
    
    if ([self.sendDelegate respondsToSelector:@selector(sendCity:)]) {
        [self.sendDelegate sendCity:selectedCity];
    }

}

@end
