//
//  TabBarViewController.m
//  project
//
//  Created by iOS－35 on 15/12/6.
//
//

#import "TabBarViewController.h"
#import "V2MenuView.h"
#import "CollectViewController.h"
#import <sqlite3.h>
#import "WHHotelModel.h"
#import "HotelViewController.h"
#import "HTCollectionTool.h"
#import "HTcolldectionModel.h"
#import "HTScenicViewController.h"
#import "HTcolldectionModel.h"
#import "HotelToll.h"
#import "SLPDealDetailViewController.h"

static CGFloat const kMenuWidth = 240.0;

@interface TabBarViewController () <UIGestureRecognizerDelegate, CollectViewControllerDelegate>
@property (nonatomic, strong) V2MenuView *menuView;
@property (nonatomic, strong) CollectViewController *collectVC;
@property (nonatomic, strong) UIButton   *rootBackgroundButton;
@property (nonatomic, strong) UIImageView *rootBackgroundBlurView;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePanRecognizer;


@end

@implementation TabBarViewController

+ (instancetype)standardTabBarViewController
{
    static TabBarViewController *vc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    });
    return vc;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddObsver(rootBackgroundButtonClick, @"goback")
    
    [self configureViews];
    [self configureGestures];
    
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgePanRecognizer.delegate = self;
    [self.collectVC.view bringSubviewToFront:self.view];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.rootBackgroundButton.frame = self.view.frame;
    self.rootBackgroundBlurView.frame = self.view.frame;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)loadView {
//    [super loadView];
//    
//    
//    
//}

- (void)configureViews {
    
    // NaviButtonBorder
    //    self.naviBottomLineView                 = [[UIView alloc] init];
    //    self.naviBottomLineView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:0.50];
    //    self.naviBottomLineView.frame           = (CGRect){0, 64, 320, 0.5};
    ////    self.naviBottomLineView.hidden = YES;
    //    [self.view addSubview:self.naviBottomLineView];
    
    self.rootBackgroundButton               = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rootBackgroundButton.alpha = 0.0;
    self.rootBackgroundButton.backgroundColor = [UIColor blackColor];
    self.rootBackgroundButton.hidden = YES;
    [self.view addSubview:self.rootBackgroundButton];
    
//    self.menuView  = [[V2MenuView alloc] initWithFrame:(CGRect){-kMenuWidth, 0, kMenuWidth, kScreenHeight}];
//    self.menuView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.menuView];
//    [self.menuView bringSubviewToFront:self.view];
    [self.view addSubview:self.collectVC.view];
    [self.collectVC.view bringSubviewToFront:self.view];

    // Handles
    [self.rootBackgroundButton addTarget:self action:@selector(rootBackgroundButtonClick) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)rootBackgroundButtonClick
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setMenuOffset:0.0f];
    }];
}

- (void)setMenuOffset:(CGFloat)offset {
    
//    self.menuView.x = offset - kMenuWidth;
//    [self.menuView setOffsetProgress:offset/kMenuWidth];
    
    self.collectVC.view.x = offset - kMenuWidth;
    [self.collectVC setOffsetProgress:offset/kMenuWidth];
    
    self.rootBackgroundButton.alpha = offset/kMenuWidth * 0.3;
    
    
    
    //    self.categoriesNavigationController.view.x   = offset/8.0;
    //    self.favoriteNavigationController.view.x     = offset/8.0;
    //    self.nofificationNavigationController.view.x = offset/8.0;
    
}




- (void)configureGestures {
    
    self.edgePanRecognizer          = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanRecognizer:)];
    self.edgePanRecognizer.edges    = UIRectEdgeLeft;
    self.edgePanRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.edgePanRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanRecognizer:)];
    panRecognizer.delegate = self;
    [self.rootBackgroundButton addGestureRecognizer:panRecognizer];
    
}

#pragma mark - Gestures
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
            return YES;
        }
        
        if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
            return YES;
        }
        
    }
    return NO;
}

- (void)handlePanRecognizer:(UIPanGestureRecognizer *)recognizer {
    
    CGFloat progress = [recognizer translationInView:self.rootBackgroundButton].x / (self.rootBackgroundButton.bounds.size.width * 0.5);
    progress = - MIN(progress, 0);
    
    [self setMenuOffset:kMenuWidth - kMenuWidth * progress];
    
    static CGFloat sumProgress = 0;
    static CGFloat lastProgress = 0;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        sumProgress = 0;
        lastProgress = 0;

    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        if (progress > lastProgress) {
            sumProgress += progress;
        } else {
            sumProgress -= progress;
        }
        lastProgress = progress;
        
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.3 animations:^{
            if (sumProgress > 0.1) {
                [self setMenuOffset:0];
            } else {
                [self setMenuOffset:kMenuWidth];
            }
        } completion:^(BOOL finished) {
            if (sumProgress > 0.1) {
                self.rootBackgroundButton.hidden = YES;
            } else {
                self.rootBackgroundButton.hidden = NO;
            }
        }];
    }
    
}



- (void)handleEdgePanRecognizer:(UIScreenEdgePanGestureRecognizer *)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / kMenuWidth;
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        //        [self setBlurredScreenShoot];
        self.rootBackgroundButton.hidden = NO;
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        [self setMenuOffset:kMenuWidth * progress];
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
        
        CGFloat velocity = [recognizer velocityInView:self.view].x;
        
        if (velocity > 20 || progress > 0.5) {
            
            [UIView animateWithDuration:(1-progress)/1.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [self setMenuOffset:kMenuWidth];
            } completion:^(BOOL finished) {
                ;
            }];
        }
        else {
            [UIView animateWithDuration:progress/3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self setMenuOffset:0];
            } completion:^(BOOL finished) {
                self.rootBackgroundButton.hidden = YES;
                self.rootBackgroundButton.alpha = 0.0;
            }];
        }
        
    }
    
}

- (CollectViewController *)collectVC {
	if(_collectVC == nil) {
		_collectVC = [CollectViewController shardCollectViewController];
        _collectVC.delegate = self;
        _collectVC.view.frame = CGRectMake(-kMenuWidth, 0, kMenuWidth, kScreenHeight);
//        _collectVC.
	}
	return _collectVC;
}

- (void)CollectViewController:(CollectViewController *)vc didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        HTScenicViewController *sectionVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"scenicVC"];
        HTcolldectionModel *collectionModel = vc.collectionArray[indexPath.row];
        sectionVC.ID = collectionModel.ID;
        sectionVC.titleName = collectionModel.name;
        sectionVC.introText = collectionModel.introText;
        UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:sectionVC];
        NC.navigationBar.barTintColor = [[UIColor alloc]initWithRed:80/255.0 green:191/255.0 blue:205/255.0 alpha:1.0];
        [self presentViewController:NC animated:YES completion:nil];
        
    }else if (indexPath.section == 1)
    {
        WHHotelModel * model = vc.hotelArray[indexPath.row];
        HotelViewController * hotelVC = [[HotelViewController alloc] initWithNibName:@"HotelViewController" bundle:nil];
        [hotelVC view];
        hotelVC.model = model;
        UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:hotelVC];
        NC.navigationBar.barTintColor = [[UIColor alloc]initWithRed:80/255.0 green:191/255.0 blue:205/255.0 alpha:1.0];
        [self presentViewController:NC animated:YES completion:^{
            
        }];
        
    }else
    {
        SLPDealDetailViewController * detatilVC = [[SLPDealDetailViewController alloc] init];
        detatilVC.deal = vc.collectDeals[indexPath.row];
        UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:detatilVC];
        NC.navigationBar.barTintColor = [[UIColor alloc]initWithRed:80/255.0 green:191/255.0 blue:205/255.0 alpha:1.0];
        [self presentViewController:NC animated:YES completion:nil];
    }
}

- (void)didReceiveShowMenu{
    
    //    [self setBlurredScreenShoot];
    
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setMenuOffset:kMenuWidth];
        self.rootBackgroundButton.hidden = NO;
    } completion:nil];
    
}

- (void)dealloc
{
    RemoveObsver
}
@end
