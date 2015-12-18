//
//  HTTripCollectionViewController.m
//  project
//
//  Created by lanou3g on 15/10/23.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTTripCollectionViewController.h"
#import "HTTripCell.h"
#import "AFNetworking.h"
#import "HTTripModel.h"
#import "HTShareRequestData.h"
#import "HTTripDataModel.h"
#import "HTCategoryCollectionViewController.h"

@interface HTTripCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)NSMutableArray * modelsArray; //存放HTTripModel的数组
@property (nonatomic, strong)HTTripCell * cell;
@property (nonatomic, strong)HTTripDataModel  * dataModel;
@property (nonatomic, strong)HTTripModel * model;
@property (nonatomic, assign)NSInteger  currentSection;
@end

@implementation HTTripCollectionViewController

static NSString * const reuseIdentifier = @"tripCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"HTTripCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    //注册header
    [self.collectionView registerClass:[HTTripCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

     [self parser];
    
    [self createCollectionView];
    
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame ) / 2 - 8, CGRectGetWidth(self.view.frame) / 2 - 8);
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 4;
    layout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
    //设置区头的大小
    layout.headerReferenceSize = CGSizeMake(0, 30);

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
    
    // 一个操作对象  和 JSON 内容  responseObject 就是 JSON 串
    
    
    [manager GET:tripListUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 返回为最外层的 数据类型
        NSDictionary *dic = responseObject;
        NSArray *array = dic[@"elements"];
        for (NSDictionary *dict in array) {
            //创建model
            HTTripModel *model = [[HTTripModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.modelsArray addObject:model];
            
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dataDic in model.data) {
                HTTripDataModel *dataModel = [[HTTripDataModel alloc] init];
                [dataModel setValuesForKeysWithDictionary:dataDic];
                [dataArray addObject:dataModel];
            }
            model.data = dataArray;
            [self.collectionView reloadData];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return self.modelsArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    HTTripModel * model = self.modelsArray[section];
    NSMutableArray *array = model.data;
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTTripCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    _model = _modelsArray[indexPath.section];
    NSMutableArray * array = _model.data;
    _dataModel =  array[indexPath.row];
    cell.model = _dataModel;
    return cell;
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //把当前的section赋给currentSection
    self.currentSection = indexPath.section;

    
    //根据kind判断设置区头还是区尾
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        //到重用集合中去取是否有可用的header
        UICollectionReusableView *handerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        handerView.backgroundColor = [UIColor cyanColor];
        
        UIView *viewOfHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        viewOfHeader.backgroundColor = [UIColor orangeColor];
        UIImageView *footerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test.jpg"]];
        footerImg.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(viewOfHeader.frame));
        [viewOfHeader addSubview:footerImg];
        //区头文字
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        sectionLabel.text = [_modelsArray[indexPath.section] title];
        [viewOfHeader addSubview:sectionLabel];
        
        //设置button
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        moreButton.frame = CGRectMake(0, 0,CGRectGetWidth(viewOfHeader.frame) , CGRectGetHeight(viewOfHeader.frame));
        moreButton.backgroundColor = [UIColor clearColor];
        [moreButton addTarget:self action:@selector(enterMoreView:) forControlEvents:UIControlEventTouchDown];
        [viewOfHeader addSubview:moreButton];
        //判断设置区头
        if (true == [self.modelsArray[indexPath.section] more]) {
            moreButton.hidden = NO;
        } else {
            moreButton.hidden = YES;
        }
        
        [handerView addSubview:viewOfHeader];
        return handerView;
        
    }
    return nil;
}


#pragma mark - 点击moreButton 的方法

- (void)enterMoreView:(UIButton *)button
{
    NSLog(@"进入更多页面");
    //推出新页面
    HTCategoryCollectionViewController *categoryVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HTCategory"];
#pragma mark -
    categoryVC.categoryID = [_modelsArray[_currentSection] indexID];
    
    [self.navigationController showViewController:categoryVC sender:nil];
    
}


#pragma mark - UICollectionViewDelegateFlowLayout代理方法
//设置cell大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(CGRectGetWidth(self.view.frame) / 2 - 20, 200);
//}

//设置区头大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 30);
}


#pragma mark - 懒加载
- (NSMutableArray *)modelsArray
{
    if (_modelsArray==nil) {
        
        _modelsArray = [NSMutableArray array];
        
    }
    
    return _modelsArray;
}


#pragma mark <UICollectionViewDelegate>


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

@end
