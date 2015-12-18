//
//  CollectViewController.m
//  project
//
//  Created by lanou3g on 15/10/30.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "CollectViewController.h"
#import <sqlite3.h>
#import "WHHotelModel.h"
#import "HotelViewController.h"
#import "HTCollectionTool.h"
#import "HTcolldectionModel.h"
#import "HTScenicViewController.h"
#import "HTcolldectionModel.h"
#import "HotelToll.h"
#import "SLPDealDetailViewController.h"

static CGFloat const kMenuWidth = 240.0;

@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView      *backgroundContainView;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *leftShadowImageView;
@property (nonatomic, strong) UIView      *leftShdowImageMaskView;

@end

@implementation CollectViewController

+ (instancetype)shardCollectViewController
{
    static CollectViewController *vc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc  = [[CollectViewController alloc]init];
    });
    return vc;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeArray" object:nil];
}
- (NSMutableArray*)hotelArray
{
    if (_hotelArray == nil) {
        _hotelArray = [NSMutableArray array];
    }
    return _hotelArray;
}

- (NSMutableArray *)collectDeals
{
    if (_collectDeals == nil) {
        _collectDeals = [NSMutableArray array];
    }
    return _collectDeals;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectDeals removeAllObjects];
    NSArray * collectDeals = [SLPMetaDataTool sharedMetaDataTool].collectDeals;
    [self.collectDeals addObjectsFromArray:collectDeals];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.clipsToBounds = NO;
    [self configureViews];
    [self configureShadowViews];
//    self.backgroundContainView.frame = CGRectMake(-kMenuWidth+5, 0, kMenuWidth, kScreenHeight);
//    self.leftShdowImageMaskView.frame = CGRectMake(-kMenuWidth+5, 0, kMenuWidth, kScreenHeight);
    
    self.view.backgroundColor = [[UIColor alloc]initWithRed:80/255.0 green:191/255.0 blue:205/255.0 alpha:1.0];
    UIImageView * backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMenuWidth, kScreenHeight)];
    backView.image = [UIImage imageNamed:@"leadingPage"];
    [self.view addSubview:backView];
    

   self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 100, ScreenW/2+30, self.view.frame.size.height-100) style:(UITableViewStylePlain)];
    // 设置隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView.backgroundColor =[UIColor clearColor];
   
    [self.view addSubview:self.tableView];
    
    
    HotelToll * hotel = [[HotelToll alloc] init];
    self.hotelArray = [hotel queryHotel];
    

    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(click) name:@"changeArray" object:nil];
    [center addObserver:self selector:@selector(HTReloadData) name:@"HTCollection" object:nil];
    [center addObserver:self selector:@selector(changeDeal) name:@"collectDeal" object:nil];
    
    [self WhHotelArry];

    ////////////////////////////////////////
    HTCollectionTool *tool = [HTCollectionTool new];
    [tool openDb];
    NSMutableArray *array = [tool queryAction];
    //取出数据库的值，显示粗来
    self.collectionArray = array;
  
    ////////////////////////////////////////

}
// 美食收藏有变化
- (void)changeDeal
{
    [self.collectDeals removeAllObjects];
    NSArray * collectDeals = [SLPMetaDataTool sharedMetaDataTool].collectDeals;
    [self.collectDeals addObjectsFromArray:collectDeals];
    [self.tableView reloadData];
}
- (void)WhHotelArry
{
    HotelToll * hotel = [[HotelToll alloc] init];
    self.hotelArray = [hotel queryHotel];

}

- (void)click
{
    [self.hotelArray removeAllObjects];
    [self WhHotelArry];
    
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        HTCollectionTool *tool = [HTCollectionTool new];
        [tool openDb];
        NSMutableArray *array = [tool queryAction];
        //取出数据库的值，显示粗来
        self.collectionArray = array;
       
        return _collectionArray.count;
    }else if (section == 1)
    {
        return self.hotelArray.count;
    }else
    {
        return self.collectDeals.count;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.delegate CollectViewController:self didSelectRowAtIndexPath:indexPath];
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.section == 0) {
        HTcolldectionModel *collectionModel = _collectionArray[indexPath.row];
        cell.textLabel.text = collectionModel.name;
        cell.textLabel.numberOfLines = 0;
        
    }else if (indexPath.section == 1)
    {
        WHHotelModel * model = self.hotelArray[indexPath.row];
    
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = model.HotelName;
        
    }else
    {
        cell.textLabel.text = [self.collectDeals[indexPath.row] title];
    }
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"旅游";
    }else if (section == 1)
    {
        return @"酒店";
    }else
    {
        return @"美食";
    }
}


#pragma mark - 懒加载
- (NSMutableArray *)collectionArray
{
    if (_collectionArray == nil) {
        _collectionArray = [NSMutableArray array];
    }
    return _collectionArray;
}

//通知的方法
- (void)HTReloadData
{
    [self.tableView reloadData];
}


#pragma mark - Public Methods

- (void)setOffsetProgress:(CGFloat)progress {
    
    progress = MIN(MAX(progress, 0.0), 1.0);
    
    self.backgroundImageView.x     = self.view.width - kScreenWidth/2 * progress;
    self.leftShadowImageView.alpha = progress;
    self.leftShadowImageView.x     = -5 + progress * 5;
    
}

- (void)configureViews {
    
    self.backgroundContainView               = [[UIView alloc] init];
    self.backgroundContainView.clipsToBounds = YES;
    [self.view addSubview:self.backgroundContainView];
    
    self.backgroundImageView = [[UIImageView alloc] init];
    [self.backgroundContainView addSubview:self.backgroundImageView];

    self.backgroundContainView.frame  = (CGRect){0, 0, self.view.width, kScreenHeight};
    self.backgroundImageView.frame    = (CGRect){kScreenWidth, 0, kScreenWidth, kScreenHeight};
}

- (void)configureShadowViews {
    
    self.leftShdowImageMaskView               = [[UIView alloc] init];
    self.leftShdowImageMaskView.clipsToBounds = YES;
    [self.view addSubview:self.leftShdowImageMaskView];
    
    UIImage *shadowImage               = [UIImage imageNamed:@"Navi_Shadow"];
    
    self.leftShadowImageView           = [[UIImageView alloc] initWithImage:shadowImage];
    self.leftShadowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    self.leftShadowImageView.alpha     = 0.0;
    [self.leftShdowImageMaskView addSubview:self.leftShadowImageView];
    
    self.leftShdowImageMaskView.frame = (CGRect){kMenuWidth, 0, 10, kScreenHeight};
    self.leftShadowImageView.frame    = (CGRect){-5, 0, 10, kScreenHeight};
    

}



@end
