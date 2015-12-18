//
//  HTStoryCollectionViewController.m
//  project
//
//  Created by lanou3g on 15/10/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTStoryCollectionViewController.h"
#import "AFNetworking.h"
#import "HTStroyDataModel.h"
#import "HTStoryListModel.h"
#import "HTStoryCell.h"
#import "HTStoryTableViewController.h"
#import "MJRefresh.h"
@interface HTStoryCollectionViewController ()<UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)NSMutableArray * StoryModelArray;
@property (nonatomic, assign)NSInteger currentCount;
@end

@implementation HTStoryCollectionViewController

static NSString * const reuseIdentifier = @"storyCell";

-(NSMutableArray *)StoryModelArray
{
    if (_StoryModelArray == nil) {
        _StoryModelArray = [NSMutableArray array];
        
    }
    return _StoryModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UINib *nib = [UINib nibWithNibName:@"HTStoryCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
//    [self parserwithURl:storyListUrl];
    [self createCollectionView];
    [self loadMoreData];
    self.currentCount = 0;
    //下拉刷新
    [self createRefreshDate];
   ;
}


- (void)viewDidAppear:(BOOL)animated
{
    //上拉加载更多
    [self loadMoreData];
}
- (void)createRefreshDate
{
    
    
    __weak HTStoryCollectionViewController *weakSelf = self;
    
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //清空数组元素
        weakSelf.StoryModelArray = nil;
        [weakSelf parserwithURl:storyListUrl];
        
            [weakSelf.collectionView.header endRefreshing];
        }];
        
   
    
    [self.collectionView.header beginRefreshing];
}


- (void)loadMoreData
{
    self.collectionView.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        self.currentCount += 12;
        
        NSString *updataUrl = [NSString stringWithFormat:@"http://api.breadtrip.com/v2/new_trip/spot/hot/list/?start=%ld",_currentCount];
        
        [self parserwithURl:updataUrl];
        [self.collectionView.footer endRefreshing];
    }];
}


- (void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame ) / 2 - 15, CGRectGetWidth(self.view.frame) / 2 - 15);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

    //滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    self.collectionView.collectionViewLayout = layout;
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)parserwithURl:(NSString *)url
{
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *  operation, id  responseObject) {
        NSMutableDictionary *dataDic = responseObject[@"data"];
   
        HTStoryListModel *model = [[HTStoryListModel alloc] init];
          [model setValuesForKeysWithDictionary:dataDic];

       
        [self.StoryModelArray addObject:model];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in model.listArray) {

            
            HTStroyDataModel *dataModel = [[HTStroyDataModel alloc] init];
            [dataModel setValuesForKeysWithDictionary:dict];
          
            
            [tempArray addObject:dataModel];
        }
        model.listArray = tempArray;
        
        [self.collectionView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}




#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return _StoryModelArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    
    HTStoryListModel *model = _StoryModelArray[section];
    NSMutableArray *array = model.listArray;
   
       return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
        HTStoryListModel *model = _StoryModelArray[indexPath.section];
        HTStroyDataModel *dataModel = model.listArray[indexPath.row];
        cell.dataModel = dataModel;
   
   
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HTStoryTableViewController *storyTVC = [[HTStoryTableViewController alloc] init];
    [self.navigationController pushViewController:storyTVC animated:YES];
    HTStoryListModel *listModel = _StoryModelArray[indexPath.section];
    HTStroyDataModel *dataModel = listModel.listArray[indexPath.row];
    storyTVC.ID = dataModel.spotID;
    storyTVC.headImgUrl = dataModel.coverImgUrl;
    storyTVC.titleName = dataModel.titleName;
    
    
//    [storyTVC parserWithUrl];
//    [storyTVC.tableView layoutIfNeeded ];
}


#pragma mark <UICollectionViewDelegate>


@end
