//
//  HTWebViewController.m
//  project
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTWebViewController.h"
#import "HTCategoryCollectionViewController.h"
@interface HTWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView * tipWebView;
@property (nonatomic, strong)UIButton * Tipsbutton;
@end

@implementation HTWebViewController

NSInteger counting = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddObsver(backToFrontTb, @"goback")
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    NSURL *url = [NSURL URLWithString:kWebUrl(self.type, self.ID)];

    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:webView];
    [self createHeaderView];
    webView.delegate = self;
    self.tabBarItem.shouldGroupAccessibilityChildren = NO;

}
- (void)createHeaderView
{
   
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    backButton.backgroundColor = [UIColor colorWithRed:61 green:179 blue:194 alpha:0.0];
    

    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backToFrontTable:) forControlEvents:UIControlEventTouchDown];

       
}
- (void)backToFrontTable:(UIButton *)button
{
     counting = 0;
//    HTCategoryCollectionViewController *categoryVC = [[HTCategoryCollectionViewController alloc] init];
//    [self dismissViewControllerAnimated:categoryVC completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)backToFrontTb
{
    counting = 0;
    //    HTCategoryCollectionViewController *categoryVC = [[HTCategoryCollectionViewController alloc] init];
    //    [self dismissViewControllerAnimated:categoryVC completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
   
}

#pragma mark - HTCategoryCollectionViewControllerDelegate代理方法
//- (void)sendTypeString:(NSString *)typeStr sendIDString:(NSString *)IDStr
//{
//    self.type = typeStr;
//    self.ID = IDStr;
//}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
}
//视图加载完成后执行的方法
- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    // 禁用用户选择
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//    
//    // 禁用长按弹出框
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (_Tipsbutton) {
        //有提示按钮，显示出来
        _Tipsbutton.hidden = NO;
    } else {
        //没有提示按钮，创建
        self.Tipsbutton = [UIButton buttonWithType:UIButtonTypeSystem];
        _Tipsbutton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 44, 0, 44, 44);
        [_Tipsbutton setBackgroundImage:[UIImage imageNamed:@"Tips"] forState:UIControlStateNormal];
        _Tipsbutton.backgroundColor = [UIColor clearColor];
        [_Tipsbutton addTarget:self action:@selector(didTipsButtonAction:) forControlEvents:UIControlEventTouchDown];
        
        [self.view addSubview:_Tipsbutton];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)didTipsButtonAction:(UIButton *)button
{
    if (_tipWebView) {
        //存在提示页面，显示出来
        _tipWebView.hidden = NO;
        
    } else {
        //不存在提示页面，创建
    self.tipWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    NSURL *url = [NSURL URLWithString:@"http://web.breadtrip.com/mobile/destination/3/67557/overview/"];
    [_tipWebView loadRequest:[NSURLRequest requestWithURL:url]];
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [closeButton addTarget:self action:@selector(closeTipsView:) forControlEvents:UIControlEventTouchDown];
        closeButton.frame = CGRectMake(0, 0, 44, 44);
       
        [_tipWebView addSubview:closeButton];
        
    [self.view addSubview:_tipWebView];
        
    }
    //点击完提示按钮隐藏
    self.Tipsbutton.hidden = YES;

}
- (void)closeTipsView:(UIButton *)button
{
    //隐藏页面
    self.tipWebView.hidden = YES;
    //关闭提示页面，按钮显示
    _Tipsbutton.hidden = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    counting ++;

    if (counting < 2) {
        return YES;
    } else {
        return NO;
    }
}

- (void)dealloc
{
    RemoveObsver
}


@end
