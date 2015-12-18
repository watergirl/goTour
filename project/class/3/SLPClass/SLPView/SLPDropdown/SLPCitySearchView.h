//
//  SLPCitySearchView.h
//  project
//
//  Created by lanou3g on 15/10/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLPCity;
@protocol SLPCitySearchViewDelegate <NSObject>

- (void)sendCity:(SLPCity*)city;

@end

@interface SLPCitySearchView : UITableView

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic,assign)id<SLPCitySearchViewDelegate>sendDelegate;

@end
