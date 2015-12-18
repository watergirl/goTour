//
//  HTStoryTableViewController.h
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTStoryTableViewController : UITableViewController
@property (nonatomic, strong)NSString * ID;
@property (nonatomic, strong)NSString * headImgUrl;
@property (nonatomic, strong)NSString * titleName;
- (void)parserWithUrl;
@end
