//
//  HTCategoryCollectionViewController.h
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTCategoryCollectionViewControllerDelegate <NSObject>

- (void)sendTypeString:(NSString *)typeStr sendIDString:(NSString *)IDStr;

@end
@interface HTCategoryCollectionViewController : UICollectionViewController
@property (nonatomic, strong)NSString * categoryID;
@property (nonatomic, assign)id<HTCategoryCollectionViewControllerDelegate> delegate;
@end
