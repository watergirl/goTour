 //
//  HTCategoryCollectionViewController.m
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTCategoryCollectionViewController.h"
#import "AFNetworking.h"
#import "HTTripCell.h"
#import "HTCategoryModel.h"
#import "HTTripCollectionViewController.h"
#import "HTWebViewController.h"
@interface HTCategoryCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic, strong)NSMutableString * titleStr;
@property (nonatomic, strong)NSMutableArray * categoryArray;
@property (nonatomic, strong)UIButton *reloadBtn;

@end

@implementation HTCategoryCollectionViewController

static NSString * const categoryIdentifier = @"tripCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"HTTripCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:categoryIdentifier];
    [self createCollectionView];
 
    [self parser];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    self.reloadBtn.hidden = YES;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self parser];
}



- (void)createCollectionView
{
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
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

- (void)parser
{
    //网络请求，解析
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    

//    NSString *strUrl = [categoryUrl stringByAppendingFormat:@"%@/",self.categoryID];
//    
//    NSLog(@"%@",strUrl);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager GET:tripListUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 返回为最外层的 数据类型
        NSDictionary *dic = responseObject;
        NSArray *array = dic[@"data"];

        
        for (NSDictionary *dataDic in array) {
             HTCategoryModel *dataModel = [[HTCategoryModel alloc] init];
            [dataModel setValuesForKeysWithDictionary:dataDic];
            [self.categoryArray addObject:dataModel];
        }
            self.reloadBtn.hidden = YES;
            [self.collectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.reloadBtn.hidden = NO;
        

    }];

}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _categoryArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTTripCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryIdentifier forIndexPath:indexPath];
    
    HTCategoryModel *model = _categoryArray[indexPath.row];
    cell.categoryModel = model;
 
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HTWebViewController *webVC = [[HTWebViewController alloc] init];
    
    
    HTCategoryModel *model = _categoryArray[indexPath.row];
    webVC.ID = model.ID;
    webVC.type = model.type;

//    if ([_delegate respondsToSelector:@selector(sendTypeString:sendIDString:)]) {
//        [_delegate sendTypeString:model.type sendIDString:model.ID];
//    }
//    
    
     [self presentViewController:webVC animated:YES completion:nil];
   


}

#pragma mark - 懒加载
- (NSMutableArray *)categoryArray
{
    if (!_categoryArray) {
        _categoryArray = [NSMutableArray array];
    }
    return _categoryArray;
}
- (UIButton *)reloadBtn {
	if(_reloadBtn == nil) {
		_reloadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_reloadBtn setTitle:@"重新加载..."];
        [_reloadBtn addTarget:self action:@selector(parser) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_reloadBtn];
        [_reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(40);
            make.center.mas_equalTo(self.view);
        }];
	}
	return _reloadBtn;
}

@end
