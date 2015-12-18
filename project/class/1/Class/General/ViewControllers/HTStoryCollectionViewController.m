//
//  HTStoryCollectionViewController.m
//  project
//
//  Created by lanou3g on 15/10/23.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTStoryCollectionViewController.h"
#import "HTStoryCell.h"
#import "AFNetworking.h"
#import "HTStoryListModel.h"
#import "HTStroyDataModel.h"
#import "HTStoryTableViewController.h"
@interface HTStoryCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)NSMutableArray * storyArray;
@end

@implementation HTStoryCollectionViewController

static NSString * const reuseIdentifier = @"storyCell";

- (void)viewWillAppear:(BOOL)animated
{
    [self parser];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"HTStoryCell" bundle:nil];
    
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];

  
    [self createCollectionView];


}

- (void)createCollectionView
{
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame ) / 2 - 10, CGRectGetWidth(self.view.frame) / 2 - 10);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    //滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    self.collectionView.collectionViewLayout = layout;
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}


- (void)parser
{
    
    //网络请求，解析
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:storyListUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 返回为最外层的 数据类型
        NSDictionary *dic = responseObject;
        NSDictionary *dict = dic[@"data"];
        
        HTStoryListModel *listModel = [[HTStoryListModel alloc] init];
        [listModel setValuesForKeysWithDictionary:dict];
        [self.storyArray addObject:listModel];
        
        NSMutableArray *mutArray = [NSMutableArray array];
        
        for (NSDictionary *dataDic in listModel.hot_spot_list) {
            HTStroyDataModel *dataModel = [[HTStroyDataModel alloc] init];
            [dataModel setValuesForKeysWithDictionary:dataDic];
            [mutArray addObject:dataModel];
        }
        
        listModel.hot_spot_list = mutArray;
        [self.collectionView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return [_storyArray.firstObject hot_spot_list].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSArray *array = [_storyArray.firstObject hot_spot_list];
    HTStroyDataModel *dataModel = array[indexPath.row];

    cell.dataModel =dataModel;
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HTStoryTableViewController *storyTVC = [[HTStoryTableViewController alloc] init];
    [self.navigationController pushViewController:storyTVC animated:YES];
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - 懒加载
- (NSMutableArray *)storyArray
{
    if (!_storyArray) {
        _storyArray = [NSMutableArray array];
    }
    return _storyArray;
}

@end
