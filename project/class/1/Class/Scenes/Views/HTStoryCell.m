//
//  HTStoryCell.m
//  project
//
//  Created by lanou3g on 15/10/23.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "HTStoryCell.h"
#import "UIImageView+AFNetworking.h"
#import "HTStroyDataModel.h"

@interface HTStoryCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end

@implementation HTStoryCell





- (void)setDataModel:(HTStroyDataModel *)dataModel
{
    _dataModel = dataModel;
    [self.imgView setImageWithURL:[NSURL URLWithString:_dataModel.imageUrl]];
    self.imgView.layer.cornerRadius = 20;
    self.imgView.layer.masksToBounds = YES;
}
@end
