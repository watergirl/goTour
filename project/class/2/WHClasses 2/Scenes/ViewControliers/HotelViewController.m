//
//  HotelViewController.m
//  project
//
//  Created by lanou3g on 15/10/30.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HotelViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+NJ.h"
#import "CollectViewController.h"
#import <sqlite3.h>
#import "HotelToll.h"
@interface HotelViewController ()
{
    sqlite3 * _db;
}
@property (nonatomic,strong)NSManagedObjectContext * context;//数据库上下文
@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *hotelPic;
@property (weak, nonatomic) IBOutlet UILabel *introl;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigh;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (nonatomic,copy)NSString * hotelPath;
@property (nonatomic,strong)NSMutableArray * nameArray;
@property (nonatomic,assign)BOOL  collection;

@property (nonatomic,strong)UIButton *button;

@end

@implementation HotelViewController
- (NSMutableArray *)nameArray
{
    if (_nameArray == nil) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddObsver(clickNA, @"goback")
    
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"确认收藏" forState:UIControlStateNormal];
//    [button setTitle:@"取消收藏" forState:UIControlStateSelected];
//    button.frame = CGRectMake(0, 0, 80, 50);
//    [button addTarget:self action:@selector(didCollectionButton:) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitleColor:[UIColor colorWithRed:75/255.0 green:160/255.0 blue:152/155.0 alpha:1] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor colorWithRed:75/255.0 green:160/255.0 blue:152/155.0 alpha:1] forState:UIControlStateSelected];
//    UIBarButtonItem * BI1 = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = BI1;
    
    self.hotelPic.layer.cornerRadius = 8;
    self.hotelPic.layer.masksToBounds = YES;
        UIBarButtonItem * clickBI = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(click)];
    self.navigationItem.leftBarButtonItem = clickBI;
    
}
- (void)click
{
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickNA
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
    [self.navigationController popViewControllerAnimated:NO];
}

//收藏功能
- (void)createCollection:(UIButton *)button
{
//    button.selected = !button.selected;
    HotelToll * hotel = [[HotelToll alloc] init];
    NSMutableArray * hotelarray= [hotel queryHotel];
    if (button.selected==YES) {
        if (hotelarray.count !=0) {
            for (WHHotelModel * model in hotelarray) {
                if ([self.model.HotelName isEqualToString:model.HotelName]) {
                    [MBProgressHUD showError:@"已经收藏"];
                }else
                {
                    [hotel collectHotel:self.model];
                    [MBProgressHUD showSuccess:@"收藏成功"];
                }
            }
        }
        else
        {
            [hotel collectHotel:self.model];
            [MBProgressHUD showSuccess:@"收藏成功"];
        }

    }
    else
    {
        
        [hotel removeHotel:self.model];
        [MBProgressHUD showSuccess:@"删除成功"];
    }
    

     NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
     [center postNotificationName:@"changeArray"object:self];

    
}
- (void)createCollectionButton
{
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _button.frame = CGRectMake(0, 0, 80, 50);
    [_button addTarget:self action:@selector(didCollectionButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitleColor:[UIColor colorWithRed:75/255.0 green:160/255.0 blue:152/155.0 alpha:1] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor colorWithRed:75/255.0 green:160/255.0 blue:152/155.0 alpha:1] forState:UIControlStateSelected];
    
    
    HotelToll * hotel = [[HotelToll alloc] init];
    if ( [hotel queryWithModel:self.model]) {
        //收藏过
        [_button setTitle:@"取消收藏" forState:UIControlStateNormal];
    } else {
        //没收藏过
        [_button setTitle:@"确认收藏" forState:UIControlStateNormal];
    }
    
    UIBarButtonItem * BI1 = [[UIBarButtonItem alloc] initWithCustomView:_button];
    self.navigationItem.rightBarButtonItem = BI1;
}

- (void)didCollectionButton:(UIButton *)button
{
    HotelToll * hotel = [[HotelToll alloc] init];
//    NSMutableArray * hotelarray= [hotel queryHotel];
    
    [hotel insertActionWithModel:self.model];
    
    if ( [hotel queryWithModel:self.model]) {
        //收藏过
        [button setTitle:@"取消收藏" forState:UIControlStateNormal];

    } else {
        //没收藏过
        [button setTitle:@"确认收藏" forState:UIControlStateNormal];

    }
    //刷新按钮状态
    [self.view setNeedsDisplay];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"changeArray"object:self];

    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createCollectionButton];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.heigh.constant = 600 + self.address.bounds.size.height + self.introl.bounds.size.height;
}
- (void)setModel:(WHHotelModel *)model
{
    _model = model;
    self.hotelName.text = model.HotelName;
    self.introl.text = model.HFHotelIntro;
    self.price.text = [NSString stringWithFormat:@"价格:%.1d",model.HFHotelPrice];
    [self.hotelPic sd_setImageWithURL:[NSURL URLWithString:model.HFHotelPic]];
    self.address.text = model.HFHotelAddress;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    RemoveObsver
}

@end
