//
//  WHHoellReusableView.h
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WHHoellReusableViewDelegate <NSObject>


- (void)touchUpInsideChainHotelButton:(UIButton *)button;
@end
@interface WHHoellReusableView : UIView
@property (nonatomic,assign)id<WHHoellReusableViewDelegate> delegate;


@end
