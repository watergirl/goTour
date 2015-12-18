//
//  SLPCityViewController.m
//  project
//
//  Created by lanou3g on 15/10/28.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPCityViewController.h"
#import "SLPCityGroup.h"
#import "SLPCity.h"
#import "SLPCitySearchView.h"
@interface SLPCityViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SLPCitySearchViewDelegate>

- (IBAction)coverClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *cover;


/** 城市组数据 */
@property (strong, nonatomic) NSArray *cityGroups;
/** 城市搜索结果界面 */
@property (nonatomic, weak) SLPCitySearchView *citySearchVc;

@end

@implementation SLPCityViewController

- (SLPCitySearchView *)citySearchVc
{
    if (_citySearchVc == nil) {
        SLPCitySearchView *citySearchVc = [[SLPCitySearchView alloc] init];
        self.citySearchVc = citySearchVc;
    }
    return _citySearchVc;
}

- (NSArray *)cityGroups
{
    if (!_cityGroups) {
        self.cityGroups = [SLPMetaDataTool sharedMetaDataTool].cityGroups;
    }
    return _cityGroups;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddObsver(back, @"goback")
    
    self.view.backgroundColor = SLPColor;
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)dealloc
{
    RemoveObsver
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



#pragma mark - UISearchBarDelegate
/** 搜索框结束编辑（退出键盘） */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 如果正在dissmis，就不要执行后面代码
    if (self.isBeingDismissed) return;
    // 更换背景
    //    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    // 隐藏取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        // 让约束执行动画
        [self.view layoutIfNeeded];
        // 让遮盖慢慢消失
        self.cover.alpha = 0.0;
    }];
    // 清空文字
    searchBar.text = nil;
    // 移除城市搜索结果界面
    [self.citySearchVc removeFromSuperview];
}

/** 搜索框开始编辑（弹出键盘） */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 更换背景
    //    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    // 显示取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    // 让整体向上挪动
    [UIView animateWithDuration:0.25 animations:^{
        // 让约束执行动画
        [self.view layoutIfNeeded];
        // 让遮盖慢慢出来
        self.cover.alpha = 0.6;
    }];
}

/** 点击了取消 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

/** 搜索框的文字发生改变的时候调用 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.citySearchVc removeFromSuperview];
    if (searchText.length > 0) {
        self.citySearchVc.backgroundColor = SLPColor;
        self.citySearchVc.sendDelegate = self;
        [self.view addSubview:self.citySearchVc];
        [self.citySearchVc autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.citySearchVc autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:searchBar];
        // 传递搜索条件
        self.citySearchVc.searchText = searchText;
    }
}

#pragma mark - 让控制器在formSheet情况下也能正常退出键盘
- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}
- (IBAction)coverClick:(id)sender{
    [self.view endEditing:YES];
}

#pragma mark - 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SLPCityGroup *group = self.cityGroups[section];
    return group.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    SLPCityGroup *group = self.cityGroups[indexPath.section];
    cell.textLabel.text = group.cities[indexPath.row];
    cell.backgroundColor = SLPColor;
    return cell;
}

#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SLPCityGroup *group = self.cityGroups[section];
    return group.title;
}

// Shift + Control + 单击 == 查看在xib\storyboard中重叠的所有UI控件
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    // 将cityGroups数组中所有元素的title属性值取出来，放到一个新的数组
    return [self.cityGroups valueForKeyPath:@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
    
    SLPCityGroup *group = self.cityGroups[indexPath.section];
    NSString *cityName = group.cities[indexPath.row];
    SLPCity * selectedCity = [[SLPMetaDataTool sharedMetaDataTool] cityWithName:cityName];
    if ([self.delegate respondsToSelector:@selector(sendView:)]) {
        [self.delegate sendView:selectedCity];
    }
    
}

- (void)sendCity:(SLPCity *)city
{
    [self.navigationController popViewControllerAnimated:YES];
    SLPCity * selectedCity = city;
    [[SLPMetaDataTool sharedMetaDataTool] saveSelectedCityName:selectedCity.name];
    if ([self.delegate respondsToSelector:@selector(sendView:)]) {
        [self.delegate sendView:selectedCity];
    }
}
@end
