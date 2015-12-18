//
//  HTStoryTableViewController.m
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTStoryTableViewController.h"
#import "AFNetworking.h"
#import "HTStoryDetailModel.h"
#import "HTStoryDetailDataModel.h"
#import "HTStoryDetailCell.h"
#import "HTHeadView.h"
@interface HTStoryTableViewController ()
@property (nonatomic, strong)NSMutableArray * detailsArray;

@end

@implementation HTStoryTableViewController

- (NSMutableArray *)detailsArray
{
    if (_detailsArray == nil) {
        _detailsArray = [NSMutableArray array];
    }
    return _detailsArray;
}

-(void)initTableView{
    
    CGRect frame = self.view.frame;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    
    //代理类
    
    self.tableView.delegate = self;
    
    //数据源
    
    self.tableView.dataSource = self;
    
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddObsver(backNA, @"goback")
    
    self.tableView.allowsSelection = NO;
    //create headView
    
    
    HTHeadView *headerView = [[HTHeadView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame) - 100) imgUrl:self.headImgUrl titleName:self.titleName titleColor:[UIColor orangeColor] titleFont:[UIFont systemFontOfSize:17]];
    headerView.backgroundColor = [UIColor cyanColor];
   

    [self initTableView];
//    [self.tableView setTableHeaderView:headerView];
    [self parserWithUrl];

}

- (void)backNA
{
    [self.navigationController popViewControllerAnimated:NO];
}



- (void)parserWithUrl
{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.breadtrip.com/v2/new_trip/spot/?spot_id=%@",self.ID];
   
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak HTStoryTableViewController * weakSelf = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data != nil) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
          
            NSDictionary *dataDic = dic[@"data"];
            NSDictionary *spotDic =dataDic[@"spot"];
            
            
           
            HTStoryDetailModel *detailModel = [[HTStoryDetailModel alloc] init];
            [detailModel setValuesForKeysWithDictionary:spotDic];
            [weakSelf.detailsArray addObject:detailModel];
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (NSDictionary *dict in detailModel.details) {
                HTStoryDetailDataModel *dataModel = [[HTStoryDetailDataModel alloc] init];
                [dataModel setValuesForKeysWithDictionary:dict];
                [array addObject:dataModel];
   
            
        }
            detailModel.details = array;
            
            [weakSelf.tableView reloadData];
            
        }
        
    }];
    [task resume];
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    HTStoryDetailModel *model = _detailsArray[section];
    NSArray *array = model.details;
    
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myIdentifier = @"myCell";
    HTStoryDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (!cell) {
        cell = [[HTStoryDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    }
    NSArray *array = [_detailsArray[indexPath.section] details];
    cell.detailDataModel = array[indexPath.row];
   
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTStoryDetailModel *model = _detailsArray[indexPath.section];
    HTStoryDetailDataModel *dataModel = model.details[indexPath.row];
    
    CGSize size = [HTStoryDetailCell sizeWithString:dataModel.text font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(self.view.frame.size.width - 20, MAXFLOAT)];
    CGFloat height = size.height + (self.view.frame.size.width *1.f) + 50;

 
    return height;
   
}

- (void)dealloc
{
    RemoveObsver
}

@end
