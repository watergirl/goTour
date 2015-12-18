//
//  AppDelegate.m
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "NewfeatureViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "TabBarViewController.h"
#import "HTRootViewController.h"
#import "SLPDealListController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self add3DTouchFunction:application];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_window makeKeyAndVisible];
    
    //查看版本
    NSString * versionKey = @"CFBundleVersion";
    versionKey=(__bridge NSString *)kCFBundleVersionKey; // 转换类型
    // 取出上次存储的版本
    NSUserDefaults * defaults = [[NSUserDefaults alloc] init];
    NSString * lastVersion = [defaults objectForKey:versionKey];
    //获取当前版本
    NSString * currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    if ([currentVersion isEqualToString:lastVersion]) {
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        MenuViewController *RootVC = story.instantiateInitialViewController;
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *RootVC = [TabBarViewController standardTabBarViewController];
        _window.rootViewController = RootVC;
    }else{
        NewfeatureViewController * NFVC = [[NewfeatureViewController alloc] init];
        _window.rootViewController = NFVC;
        [defaults setObject:currentVersion forKey:versionKey];//存储版本
        [defaults synchronize];//立刻写入
    }
    //4监控网络状态
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    // 网络状态改变时 调用
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网路
            case AFNetworkReachabilityStatusNotReachable: // 没有网络
                [MBProgressHUD showError:@"网络异常，请检查网络设置！"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网路
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // wifi网路
                break;
            default:
                break;
        }
    }];
    // 开始监控
    [mgr startMonitoring];
    
    
    
    return YES;
}
// 处理内存问题
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 清除所有的内存缓存
    [[SDImageCache sharedImageCache] clearMemory];
    //   停止正在进行的图片下载操作
    [[SDWebImageManager sharedManager] cancelAll];
}

//添加3DTouch
- (void)add3DTouchFunction:(UIApplication *)application
{
    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"1" localizedTitle:@"附近景点"];
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"touch_1"];
    item1.icon = icon1;
    
    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"2" localizedTitle:@"每日故事"];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"touch_2"];
    item2.icon = icon2;
    
    UIMutableApplicationShortcutItem *item3 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"3" localizedTitle:@"预定酒店"];
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"touch_3"];
    item3.icon = icon3;
    
    UIMutableApplicationShortcutItem *item4 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"4" localizedTitle:@"搜索团购"];
    UIApplicationShortcutIcon *icon4 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"touch_4"];
    item4.icon = icon4;
    
    application.shortcutItems = @[item1, item2, item3, item4];
    
}

//3DTouch代理方法
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    TabBarViewController *tbVC = nil;
    if ([_window.rootViewController isKindOfClass:[TabBarViewController class]]) {
        tbVC = (TabBarViewController *)_window.rootViewController;
    }

//    tbVC = (TabBarViewController *)_window.rootViewController;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goback" object:self];
    
//    [NaViewController instantNvc];
//    [SLPDealListController instantNvc];
    
    switch (shortcutItem.type.integerValue) {
        case 1:
        {
            tbVC.selectedIndex = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"toNearbyVC" object:self userInfo:@{@"type":@"nearby"}];
            });
            break;
        }
        case 2:
        {
            tbVC.selectedIndex = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"toNearbyVC" object:self userInfo:@{@"type":@"story"}];
            });
            break;
        }
        case 3:
            tbVC.selectedIndex = 1;
            break;
        case 4:
        {
            tbVC.selectedIndex = 2;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"clickSearchItem" object:self];
            });
            break;
        }
        default:
            break;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
