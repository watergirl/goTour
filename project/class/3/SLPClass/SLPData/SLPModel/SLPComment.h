//
//  SLPComment.h
//  project
//
//  Created by lanou3g on 15/10/31.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLPComment : NSObject

@property (nonatomic,strong)NSString * review_id ;
@property (nonatomic,strong)NSString *  user_nickname ;
@property (nonatomic,strong)NSString *  created_time ;
@property (nonatomic,strong)NSString *  text_excerpt ;
@property (nonatomic,strong)NSString *  review_rating;
@property (nonatomic,strong)NSString *  rating_img_url;
@property (nonatomic,strong)NSString *  rating_s_img_url;
@property (nonatomic,strong)NSString *  product_rating;
@property (nonatomic,strong)NSString *  decoration_rating;
@property (nonatomic,strong)NSString *  service_rating;
@property (nonatomic,strong)NSString *  review_url;
@property (nonatomic,strong)NSString *  additional_info;

@end
