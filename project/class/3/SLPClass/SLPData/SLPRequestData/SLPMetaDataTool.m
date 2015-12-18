//
//  SLPMetaDataTool.m
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPMetaDataTool.h"
#import "SLPCategoryName.h"
#import "SLPCity.h"
#import "SLPCityGroup.h"
#import "SLPSort.h"
#define SelectedCityNamesFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selected_city_names.plist"]


#define CollectDealsFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"collect_deals.data"]


@interface SLPMetaDataTool ()

{
    /** 所有的分类 */
    NSArray *_categories;
    /** 所有的城市 */
    NSArray *_cities;
    /** 所有的城市组 */
    NSArray *_cityGroups;
    /** 所有的排序 */
    NSArray *_sorts;
    
    // 所有收藏的团购
    NSMutableArray *_collectDeals;
}
@property (nonatomic, strong) NSMutableArray *selectedCityNames;
@end
@implementation SLPMetaDataTool

static id _data = nil;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _data = [super allocWithZone:zone];
    });
    return _data;
}
+ (instancetype)sharedMetaDataTool
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _data = [[self  alloc] init];
    });
    return _data;
}
- (id)copyWithZone:(NSZone *)zone
{
    return _data;
}


- (NSArray *)categories
{
    if (!_categories) {
        _categories = [SLPCategoryName objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}

- (NSArray *)cityGroups
{
    NSMutableArray * cityGroups = [NSMutableArray array];
    if (self.selectedCityNames.count) {
        SLPCityGroup * recentCityGroup = [[SLPCityGroup alloc] init];
        recentCityGroup.title = @"最近";
        recentCityGroup.cities = self.selectedCityNames;
        [cityGroups addObject:recentCityGroup];
    }
    NSArray * plist = [SLPCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    [cityGroups addObjectsFromArray:plist];
    return cityGroups;
}

- (NSArray *)cities
{
    if (!_cities) {
        _cities = [SLPCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

- (NSArray *)sorts
{
    if (!_sorts) {
        _sorts = [SLPSort objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}


- (SLPCity *)cityWithName:(NSString *)name
{
    if (name.length == 0) return nil;
    
    for (SLPCity *city in self.cities) {
        if ([city.name isEqualToString:name]) return city;
    }
    return nil;
}

/*  存储选中的子分类名字*/
- (void)saveSelectedCityName:(NSString *)name
{
    if (name.length == 0) return;
    
    // 存储城市名字
    [self.selectedCityNames removeObject:name];
    [self.selectedCityNames insertObject:name atIndex:0];
    
    // 写入plist
    [self.selectedCityNames writeToFile:SelectedCityNamesFile atomically:YES];
    
}

- (NSMutableArray *)selectedCityNames
{
    if (!_selectedCityNames) {
        _selectedCityNames = [NSMutableArray arrayWithContentsOfFile:SelectedCityNamesFile];
        if (!_selectedCityNames) {
            _selectedCityNames = [NSMutableArray array];
        }
    }
    return _selectedCityNames;
}
- (SLPCity *)selectedCity
{
    NSString *cityName = [self.selectedCityNames firstObject];
    SLPCity *city = [self cityWithName:cityName];
    if (city == nil) {
        city = [self cityWithName:@"北京"];
    }
    return city;
}


#pragma mark - 收藏
- (NSMutableArray *)collectDeals
{
    if (!_collectDeals) {
        _collectDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:CollectDealsFile];
        
        if (!_collectDeals) {
            _collectDeals = [NSMutableArray array];
        }
    }
    return _collectDeals;
}
- (void)saveCollectDeal:(SLPDeal *)deal
{
    [self.collectDeals removeObject:deal];
    [self.collectDeals insertObject:deal atIndex:0];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:CollectDealsFile];
}

- (void)unsaveCollectDeal:(SLPDeal *)deal
{
    [self.collectDeals removeObject:deal];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:CollectDealsFile];
}


- (void)unsaveCollectDeals:(NSArray *)deals
{
    [self.collectDeals removeObjectsInArray:deals];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:CollectDealsFile];
}

@end
