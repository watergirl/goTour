//
//  WHCityTableViewController.h
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WHCityTableViewControllerDelegate <NSObject>

- (void)sendView:(NSString*)text;

@end
@interface WHCityTableViewController : UITableViewController
@property (nonatomic,assign)id<WHCityTableViewControllerDelegate>delegate;


@end
