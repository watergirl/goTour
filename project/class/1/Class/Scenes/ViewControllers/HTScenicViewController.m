//
//  HTScenicViewController.m
//  project
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTScenicViewController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "HTScenicModel.h"
#import "HTScenicDatailCell.h"
#import "HTImageModel.h"
#import "HTLocationModel.h"
#import "HTMapViewController.h"
#import "HTCollectionTool.h"
#import "HTNearbyTableViewController.h"
@interface HTScenicViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UIView *contentView;

@property (strong, nonatomic)  UIImageView *coverView;

@property (strong, nonatomic)  UILabel *titleNameLabel;
@property (strong, nonatomic)  UILabel *introlLabel;
@property (nonatomic, strong)NSMutableArray * modelArray; //存放model的数组
@property (nonatomic, strong)NSArray * headerArray;
@property (nonatomic, strong)NSArray * contentArray; //保存cell内容的数组
@property (nonatomic, assign)CGFloat currentHeight;
@property (nonatomic, strong)HTNearbyDataModel * model;
@property (nonatomic, strong)UIButton * button;
@end

@implementation HTScenicViewController

- (NSMutableArray *)modelArray
{
    if (_modelArray == nil) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

static NSString * const scenicIdentifier = @"secnicDetailCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddObsver(backNA, @"goback")
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) / 1.5)];
   
    self.coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.contentView.frame) / 5 * 3)];
    
    
//    //注册cell
//    UINib *nib = [UINib nibWithNibName:@"HTScenicDatailCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:scenicIdentifier];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.headerArray = @[@"概况",@"到达",@"开放时间",@"地址",@"电话",@"地图"];
    
    //给头部视图赋值（图片需要再请求）
    self.titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.coverView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.contentView.frame) / 5)];
   
    self.titleNameLabel.text = self.titleName;
    self.titleNameLabel.textAlignment = NSTextAlignmentCenter;
    self.titleNameLabel.font = [UIFont systemFontOfSize:20];
    
     self.introlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame) / 5 * 4, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.contentView.frame) / 5 )];
    self.introlLabel.text = self.introText;
    self.introlLabel.numberOfLines = 0;
    self.introlLabel.textAlignment = NSTextAlignmentCenter;
    
    self.introlLabel.font = [UIFont systemFontOfSize:16];
    //添加到contentView上
    [self.contentView addSubview:_coverView];
    [self.contentView addSubview:_titleNameLabel];
    [self.contentView addSubview:_introlLabel];
    
    //设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.scenicDetailTableView.scrollEnabled = YES;
   
    

    NSString *parserUrl = [NSString stringWithFormat:@"http://api.breadtrip.com/destination/place/5/%@/",self.ID];
    [self parserWithUrl:parserUrl];
    
    UIBarButtonItem * clickBI = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(click)];
    self.navigationItem.leftBarButtonItem = clickBI;
    //添加到headerView上
    self.tableView.tableHeaderView = self.contentView;
 
}

- (void)click
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
   
//    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self createCollectionButton];
}
- (void)viewDidAppear:(BOOL)animated
{
    HTScenicModel *model = _modelArray.firstObject;
    HTImageModel *imgModel = model.imageArray.firstObject;
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:imgModel.photo]];

//    //创建收藏按钮
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(didClickCollectionButton:)];
//    self.navigationItem.rightBarButtonItem = item;
//    [self.tableView reloadData];
    
}

- (void)createCollectionButton
{
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _button.frame = CGRectMake(0, 0, 80, 50);
    [_button addTarget:self action:@selector(didCollectionButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitleColor:[UIColor colorWithRed:75/255.0 green:160/255.0 blue:152/155.0 alpha:1] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor colorWithRed:75/255.0 green:160/255.0 blue:152/155.0 alpha:1] forState:UIControlStateSelected];

    
    HTCollectionTool *tool = [HTCollectionTool new];
    if ( [tool queryWithID:self.ID]) {
        //收藏过
        [_button setTitle:@"取消收藏" forState:UIControlStateNormal];
    } else {
        //没收藏过
        [_button setTitle:@"确认收藏" forState:UIControlStateNormal];
    }
   
       UIBarButtonItem * BI1 = [[UIBarButtonItem alloc] initWithCustomView:_button];
    self.navigationItem.rightBarButtonItem = BI1;
}


- (void)parserWithUrl:(NSString *)url
{
    
    NSURL *parserUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:parserUrl];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak HTScenicViewController * weakSelf = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data != nil) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            HTScenicModel *model = [[HTScenicModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.modelArray addObject:model];
            //把model的属性装进数组
            //为空判断
            if (model.introText == nil) {
                model.introText = @"暂无数据";
            }
            if (model.arrival_type == nil) {
                model.arrival_type = @"暂无数据";
            }
            if (model.opening_time == nil) {
                model.opening_time = @"暂无数据";
            }
            if (model.address == nil) {
                model.address = @"暂无数据";
            }
            if (model.tel == nil) {
                model.tel = @"暂无数据";
            }
            _contentArray = @[model.introText,model.arrival_type,model.opening_time,model.address,model.tel,@"点击查看地图"];
            
            //解析图片数组
            NSMutableArray *imgArray = [NSMutableArray array];
            for (NSDictionary *dic in model.imageArray) {
               HTImageModel *imageModel = [[HTImageModel alloc] init];
                [imageModel setValuesForKeysWithDictionary:dic];
                [imgArray addObject:imageModel];
            }
            model.imageArray = imgArray;
            
            //位置
            NSMutableArray *locationArray = [NSMutableArray array];
            HTLocationModel *locationModel = [[HTLocationModel alloc] init];
            [locationModel setValuesForKeysWithDictionary:model.location];
            [locationArray addObject:locationModel];
            model.locationArray = locationArray;
           
            }
        
            [weakSelf.tableView reloadData];
     
    }];
   
    [task resume];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   HTScenicDatailCell *cell = [tableView dequeueReusableCellWithIdentifier:scenicIdentifier];
    if (cell == nil) {
        cell = [[HTScenicDatailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:scenicIdentifier];
    }

    HTScenicModel *model = _modelArray.firstObject;
    cell.contentView.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:245 / 255.0 blue:232 / 255.0 alpha:1];
    
    cell.textLabel.numberOfLines = 0;
    
    switch (indexPath.section) {
        case 0: {
             cell.introLabel.text = model.introText;
            
            break;
        }
        case 1: {
            cell.introLabel.text = model.arrival_type;
            break;
        }
        case 2: {
            cell.introLabel.text = model.opening_time;
            break;
        }
        case 3: {
            cell.introLabel.text = model.address;
            break;
        }
        case 4: {
            cell.introLabel.text = model.tel;
            break;
        }
        case 5: {
            cell.introLabel.text = @"点击查看地图";
           
            break;
        }
            
        default:
            break;
    }
    
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (5 == indexPath.section) {
        //推出地图页面
        HTMapViewController *mapVC = [[HTMapViewController alloc] init];
        HTScenicModel *model = _modelArray.firstObject;
        HTLocationModel *locationModel = model.locationArray.firstObject;
        
        mapVC.latitude = locationModel.latutide;
        mapVC.longitude = locationModel.longitude;
        mapVC.annotationName = model.name;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _headerArray[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [HTScenicDatailCell sizeWithString:_contentArray[indexPath.section] font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(self.view.frame.size.width - 20, MAXFLOAT)];
    CGFloat height = size.height  + 50;

    return height;

}

//- (void)didClickCollectionButton:(UIBarButtonItem *)item
//{
//    
//    HTCollectionTool *tool = [HTCollectionTool new];
//    [tool insertActionWithID:self.ID name:self.titleName introText:self.introText];
//    
////    [tool queryAction];
//    //取消收藏
//    
//    
//    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
//    [center postNotificationName:@"HTCollection"object:self];
//
//    
//}

- (void)didCollectionButton:(UIButton *)button
{
 
    HTCollectionTool *tool = [HTCollectionTool new];
 
    [tool insertActionWithID:self.ID name:self.titleName introText:self.introText];
    
    if ( [tool queryWithID:self.ID]) {
        //收藏过
        [_button setTitle:@"取消收藏" forState:UIControlStateNormal];
    } else {
        //没收藏过
        [_button setTitle:@"确认收藏" forState:UIControlStateNormal];
    }
    //刷新按钮状态
    [self.tableView reloadData];
    

    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"HTCollection"object:self];

}

- (void)backNA
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)dealloc
{
    RemoveObsver
}

@end
