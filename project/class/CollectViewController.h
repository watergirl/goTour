//
//  CollectViewController.h
//  project
//
//  Created by lanou3g on 15/10/30.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectViewController;
@protocol CollectViewControllerDelegate <NSObject>

- (void)CollectViewController:(CollectViewController *)vc didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CollectViewController : UIViewController
@property (nonatomic,strong)UITableView* tableView;
@property (nonatomic, weak) id<CollectViewControllerDelegate> delegate;
- (void)setOffsetProgress:(CGFloat)progress;
+ (instancetype)shardCollectViewController;

@property (nonatomic,strong)NSMutableArray * hotelArray;
@property (nonatomic, strong)NSMutableArray * collectionArray;
@property (nonatomic, strong)NSMutableArray *collectDeals;


@end
