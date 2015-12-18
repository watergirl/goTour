//
//  WHHoellReusableView.m
//  project
//
//  Created by lanou3g on 15/10/22.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "WHHoellReusableView.h"

@interface WHHoellReusableView ()
@property (weak, nonatomic) IBOutlet UIButton *click;//设置默认选中
- (IBAction)buttonClick:(UIButton *)sender;

@property (nonatomic,strong)UIButton * button;//设置当前选中的button

@end
@implementation WHHoellReusableView

- (void)awakeFromNib {

    self.click.enabled = NO;//设置默认选中
    
}

- (IBAction)buttonClick:(UIButton *)sender {
    
    self.click.enabled = YES;
    self.button.enabled = YES;
    self.button = sender;
    if ([self.delegate respondsToSelector:@selector(touchUpInsideChainHotelButton:) ]) {
        
        [_delegate touchUpInsideChainHotelButton:sender];
    }
    self.button.enabled = NO;
}
@end
