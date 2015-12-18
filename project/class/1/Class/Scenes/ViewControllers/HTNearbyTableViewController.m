//
//  NearbyTableViewController.m
//  project
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTNearbyTableViewController.h"
#import "HTNearbyCell.h"
#import "AFNetworking.h"
#import "HTNearbyDataModel.h"
#import "HTNearbyModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "HTScenicViewController.h"
@interface HTNearbyTableViewController ()
@property (nonatomic, strong)NSMutableArray * nearbyModelArray;
@property (nonatomic, assign)NSInteger currentCount;
@end

@implementation HTNearbyTableViewController
static NSString *reuseIdentifier = @"nearbyCell";

#pragma maek - 懒加载
- (NSMutableArray *)nearbyModelArray
{
    if (_nearbyModelArray == nil) {
        _nearbyModelArray = [NSMutableArray array];
    }
    return  _nearbyModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentCount = 0;
    
    AddObsver(backNA, @"goback")
    
    NSString *parserUrl = [NSString stringWithFormat:@"http://api.breadtrip.com/place/pois/nearby/?category=11&start=0&count=20&latitude=%@&longitude=%@",self.latitude,self.longitude];
     [self parserWithUrlWithUrl:parserUrl];
//    [self parserWithUrlWithUrl:@"http://api.breadtrip.com/place/pois/nearby/?category=11&start=0&count=20&latitude=40.030379999999994&longitude=116.34346800000003"];
   
    
    [self createRefreshDate];
    [self loadMoreData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


//下拉刷新
- (void)createRefreshDate
{
    
    
    __weak HTNearbyTableViewController *weakSelf = self;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //清空数组元素
        weakSelf.nearbyModelArray = nil;
        //重新请求
        [weakSelf parserWithUrlWithUrl:[NSString stringWithFormat:@"http://api.breadtrip.com/place/pois/nearby/?category=11&start=0&count=20&latitude=%@&longitude=%@",self.latitude,self.longitude]];
        
        [weakSelf.tableView.header endRefreshing];
    }];
    
    
    
    [self.tableView.header beginRefreshing];
}



//上拉加载
- (void)loadMoreData
{
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        self.currentCount += 20;
        
        NSString *updataUrl = [NSString stringWithFormat:@"http://api.breadtrip.com/place/pois/nearby/?category=11&start=%ld&count=20&latitude=%@&longitude=%@",_currentCount,self.latitude,self.longitude];
       
        [self parserWithUrlWithUrl:updataUrl];
        [self.tableView.footer endRefreshing];
    }];
}





- (void)parserWithUrlWithUrl:(NSString *)url
{
  
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak HTNearbyTableViewController * weakSelf = self;
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 返回为最外层的 数据类型
       
        NSMutableDictionary *dict = responseObject;
            HTNearbyModel *model = [[HTNearbyModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [weakSelf.nearbyModelArray addObject:model];

            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in model.items) {
                HTNearbyDataModel *dataModel = [[HTNearbyDataModel alloc] init];
                [dataModel setValuesForKeysWithDictionary:dic];
                [array addObject:dataModel];
            
            }
            model.items = array;

       
            //刷新数据
            [weakSelf.tableView reloadData];
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _nearbyModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    HTNearbyModel *model = _nearbyModelArray[section];
    NSMutableArray *array = model.items;
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTNearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    HTNearbyModel *model = _nearbyModelArray[indexPath.section];
    HTNearbyDataModel *dataModel = model.items[indexPath.row];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor colorWithRed:250 /255.0 green:245/255.0 blue:232/255.0 alpha:1];
    cell.dataModel = dataModel;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTScenicViewController *scenicVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scenicVC"];
    HTNearbyModel *model = _nearbyModelArray[indexPath.section];
    HTNearbyDataModel *dataModel = model.items[indexPath.row];
    
    scenicVC.ID = dataModel.ID;
    scenicVC.titleName = dataModel.name;
    scenicVC.imgView = dataModel.headImage;
    scenicVC.introText = dataModel.recommendText;
//    [self.navigationController pushViewController:scenicVC animated:YES];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:scenicVC];
    nvc.navigationBar.barTintColor = [[UIColor alloc]initWithRed:80/255.0 green:191/255.0 blue:205/255.0 alpha:1.0];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HTNearbyModel *model = _nearbyModelArray[indexPath.section];
    HTNearbyDataModel *dataModel = model.items[indexPath.row];
  
   
    CGSize size = [HTNearbyCell sizeWithString:dataModel.recommendText font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(self.view.frame.size.width - 20, MAXFLOAT)];
    CGFloat height = size.height + 100;
    
    return height;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}

- (void)backNA
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)dealloc
{
    RemoveObsver
}

@end
