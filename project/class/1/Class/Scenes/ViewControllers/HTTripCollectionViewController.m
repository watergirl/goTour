//
//  HTTripCollectionViewController.m
//  project
//
//  Created by lanou3g on 15/10/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTTripCollectionViewController.h"
#import "HTTripCell.h"
#import "AFNetworking.h"
#import "HTCategoryCollectionViewController.h"
#import "HTCategoryModel.h"
@interface HTTripCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong)NSMutableArray * categoryArray;
@end

@implementation HTTripCollectionViewController

static NSString * const reuseIdentifier = @"tripCell";

#pragma mark - 懒加载
- (NSMutableArray *)categoryArray
{
    if (_categoryArray == nil) {
        _categoryArray = [NSMutableArray array];
    }
    return _categoryArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"HTTripCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];


   
    [self createCollectionView];
 
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame ) / 2 - 40, CGRectGetWidth(self.view.frame) / 2 - 20);
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.headerReferenceSize = CGSizeMake(self.collectionView.size.width, 30);
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
    
    
    //    NSString *strUrl = [categoryUrl stringByAppendingFormat:@"%@/",self.categoryID];
    //
    //    NSLog(@"%@",strUrl);
    
    [manager GET:@"http://api.breadtrip.com/destination/index_places/8/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 返回为最外层的 数据类型
        NSDictionary *dic = responseObject;
        NSArray *array = dic[@"data"];
        //        self.titleStr = dic[@"title"];
        
        for (NSDictionary *dataDic in array) {
            HTCategoryModel *dataModel = [[HTCategoryModel alloc] init];
            [dataModel setValuesForKeysWithDictionary:dataDic];
            [self.categoryArray addObject:dataModel];
        }
        
        [self.collectionView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    
}





#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    
    
    return _categoryArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTTripCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    HTCategoryModel *model = [[HTCategoryModel alloc] init];
    cell.categoryModel = model;
    return cell;
}




#pragma mark <UICollectionViewDelegate>



@end
