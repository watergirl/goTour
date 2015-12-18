//
//  MenuViewController.m
//  project
//
//  Created by lanou3g on 15/10/30.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)awakeFromNib
{
    self.contentViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"bar"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"left"];
    self.rightMenuViewController = nil;
    self.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
