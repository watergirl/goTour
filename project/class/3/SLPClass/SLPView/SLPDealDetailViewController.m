//
//  SLPDealDetailViewController.m
//  project
//
//  Created by lanou3g on 15/10/27.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPDealDetailViewController.h"
#import "SLPDeal.h"
#import "SLPGetSingleDealParam.h"
#import "SLPDealTool.h"
#import "SLPGetSingleDealResult.h"
#import "SLPRestriction.h"
#import "UIImageView+WebCache.h"
#import "SLPDealDetailView1.h"
#import "SLPBusiness.h"
#import "SLPGetSingleDealCommentResult.h"
#import "SLPGetSingleDealCommentParam.h"
#import "SLPMetaDataTool.h"
@interface SLPDealDetailViewController ()
 @property (nonatomic,weak)UIImageView * zoomImageView;
@property (nonatomic,weak)UIScrollView * scrollView;
@property (nonatomic,weak)SLPDealDetailView1 * detailView;
// 按钮
@property (weak, nonatomic)  UIButton *collectButton;
// label
@property (weak, nonatomic)  UILabel *titleLabel;
@property (weak, nonatomic)  UILabel *descLabel; // 描述
@property (weak, nonatomic)  UILabel *detailLabel;
@property (weak, nonatomic)  UILabel *stipLabel;
@property (weak, nonatomic)  UILabel *noticeLabel;

@property (weak, nonatomic)UITableView * commentView;

@property (strong, nonatomic)NSMutableArray * commentArray;
@property (strong, nonatomic)SLPDeal * requestDeal;
@end

@implementation SLPDealDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"团购详情";

    self.view.backgroundColor = SLPColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backNA) name:@"goback" object:nil];

    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.view.height)];
    scrollView.backgroundColor = SLPColor;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIImageView *zoomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*28.0/45.0)];
    [zoomImageView sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    [self.scrollView addSubview:zoomImageView];
    self.zoomImageView = zoomImageView;
    
//    UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-44,20, 44, 44)];
//    [collectButton addTarget:self action:@selector(clickCollectItem) forControlEvents:(UIControlEventTouchUpInside)];
//    [collectButton setTitle:@"收藏"];
//    collectButton.titleColor = [UIColor colorWithRed:15/255.0 green:129/255.0 blue:254/255.0 alpha:1];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:collectButton];
//    [self.view addSubview:collectButton];
//    self.collectButton = collectButton;
    
    
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;

    
    // 加载内容
    [self loadData];

    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createCollectionButton];
    
}


- (void)createCollectionButton
{
    UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    self.collectButton = collectButton;
    [collectButton addTarget:self action:@selector(clickCollectItem) forControlEvents:(UIControlEventTouchUpInside)];
    [_collectButton setTitleColor:[UIColor colorWithRed:75/255.0 green:160/255.0 blue:152/155.0 alpha:1] forState:UIControlStateNormal];
    [_collectButton setTitleColor:[UIColor colorWithRed:75/255.0 green:160/255.0 blue:152/155.0 alpha:1] forState:UIControlStateSelected];

    
//    [self.view addSubview:collectButton];

    NSArray *collectDeals = [SLPMetaDataTool sharedMetaDataTool].collectDeals;
    self.collectButton.selected = [collectDeals containsObject:self.deal];
    if (self.collectButton.selected) {

        [_collectButton setTitle:@"取消收藏" forState:UIControlStateNormal];
    } else {

        [_collectButton setTitle:@"确认收藏" forState:UIControlStateNormal];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:collectButton];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backNA
{
    [self dismissViewControllerAnimated:NO completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickCollectItem
{
    // 判断是否收藏
    NSArray *collectDeals = [SLPMetaDataTool sharedMetaDataTool].collectDeals;
    self.collectButton.selected = [collectDeals containsObject:self.deal];
    
    if (self.collectButton.selected) {
        [[SLPMetaDataTool sharedMetaDataTool] unsaveCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"取消收藏成功！"];
//        self.collectButton.titleColor = [UIColor colorWithRed:15/255.0 green:129/255.0 blue:254/255.0 alpha:1];
        [self.collectButton setTitle:@"确认收藏" forState:UIControlStateNormal];
        self.collectButton.selected = NO;
    } else {
        [[SLPMetaDataTool sharedMetaDataTool] saveCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"收藏成功！"];
        [self.collectButton setTitle:@"取消收藏" forState:UIControlStateNormal];
//        self.collectButton.titleColor = [UIColor redColor];
        self.collectButton.selected = YES;
    }
    [self.view setNeedsDisplay];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectDeal" object:nil];
}
- (void)loadData
{
    // 加载更详细的团购数据
    SLPGetSingleDealParam *param = [[SLPGetSingleDealParam alloc] init];
    param.deal_id = self.deal.deal_id;
    [SLPDealTool getSingleDeal:param success:^(SLPGetSingleDealResult *result) {
        if (result.deals.count) {
            self.requestDeal = [result.deals lastObject];
            // 更新内容
            [self setupView];
        } else {
            [MBProgressHUD showError:@"没有找到指定的团购信息"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"加载团购数据失败"];
    }];
}
- (void)setupView
{
     CGSize maxSize=CGSizeMake(ScreenW-20, MAXFLOAT);
    
    // 标题
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.zoomImageView.frame)+10, ScreenW-20, 40)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = self.requestDeal.title;
    self.titleLabel = titleLabel;
    [self.scrollView addSubview:titleLabel];
    
    // 描述
    UILabel * descLabel = [[UILabel alloc] init];
    descLabel.font = [UIFont systemFontOfSize:15];
    descLabel.numberOfLines = 0;
    NSString * desc = [NSString stringWithFormat:@"%@", self.requestDeal.desc];
    CGSize descSize=[desc sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:maxSize];
    descLabel.frame=(CGRect){{10,CGRectGetMaxY(self.titleLabel.frame)+5},descSize};
    descLabel.text = self.requestDeal.desc;
    [self.scrollView addSubview:descLabel];
    self.descLabel = descLabel;
    
    SLPDealDetailView1 * detailView = [SLPDealDetailView1 menu];
    detailView.frame=(CGRect){0,CGRectGetMaxY(self.descLabel.frame)+20,ScreenW, 240};
    detailView.deal = self.requestDeal;
    [self.scrollView addSubview:detailView];
    self.detailView = detailView;

    /// 须知
    UILabel *stipLabel = [[UILabel alloc] init];
    stipLabel.font = [UIFont systemFontOfSize:15];
    stipLabel.numberOfLines = 0;
    NSString * notice = [NSString stringWithFormat:@"%@", self.requestDeal.restrictions.special_tips];
    CGSize noticeSize=[notice sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:maxSize];
    stipLabel.frame=(CGRect){{10,CGRectGetMaxY(self.detailView.frame)+50},noticeSize};
    stipLabel.text = self.requestDeal.restrictions.special_tips;
    stipLabel.textColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1.0];
    [self.scrollView addSubview:stipLabel];
    self.stipLabel = stipLabel;

    
    self.scrollView.contentSize = CGSizeMake(ScreenW, CGRectGetMaxY(self.stipLabel.frame)+20);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
