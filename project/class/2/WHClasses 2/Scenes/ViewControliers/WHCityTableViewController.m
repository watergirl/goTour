//
//  WHCityTableViewController.m
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "WHCityTableViewController.h"
#import "WHUrl.h"
#import "WHCityTableViewCell.h"
#import "WHCityModel.h"
#import "AFNetworking.h"
@interface WHCityTableViewController ()

@property (nonatomic,strong)NSMutableArray * WHcityListArray;//保存城市列表数组
@property (nonatomic,assign)int thmid;//酒店类型
@end

@implementation WHCityTableViewController
static NSString * const WHreuseIdentifier = @"cityCell";
#pragma mark=====懒加载
- (NSMutableArray *)WHcityListArray
{
    if (_WHcityListArray == nil) {
        _WHcityListArray = [NSMutableArray array];
        //获取网址对象
        NSURL * url = [NSURL URLWithString:WHCityUrl(self.thmid)];
        NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (data != nil) {
                NSMutableArray * array =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                for ( NSMutableDictionary * dic  in array) {
                    WHCityModel * model = [WHCityModel WHCityModelWithDict:dic];
                    [_WHcityListArray addObject:model];
                }
            }
            [self.tableView reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
        
    }
    return _WHcityListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddObsver(back, @"goback");
    
    //取消tableView的滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    //默认类型
    self.thmid = 20;
    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.WHcityListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WHCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WHreuseIdentifier forIndexPath:indexPath];
    WHCityModel * cityModel = _WHcityListArray[indexPath.row];
    cell.whCityModel = cityModel;
    cell.textLabel.text = cell.cityName;
    cell.detailTextLabel.text = cell.proName;
    return cell;
}
//cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
    
    WHCityModel * cityModel = _WHcityListArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(sendView:)]) {
     [self.delegate sendView:[NSString stringWithFormat:@"%d",cityModel.CityId]];

    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)dealloc
{
    RemoveObsver
}

@end
