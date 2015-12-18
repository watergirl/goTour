//
//  SLPDealTool.h
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPFindDealParam.h"
#import "SLPFindDealResult.h"
#import "SLPGetSingleDealParam.h"
#import "SLPGetSingleDealResult.h"
#import "SLPGetSingleDealCommentParam.h"
#import "SLPGetSingleDealCommentResult.h"
@interface SLPDealTool : NSObject


+ (void)findDeals:(SLPFindDealParam *)param success:(void(^)(SLPFindDealResult *result))success failure:(void(^)(NSError *error))failure;

+ (void)getSingleDeal:(SLPGetSingleDealParam *)param success:(void(^)(SLPGetSingleDealResult *result))success failure:(void(^)(NSError * error))failure;

+ (void)getSingleDealComment:(SLPGetSingleDealCommentParam *)param success:(void(^)(SLPGetSingleDealCommentResult *result))success failure:(void(^)(NSError * error))failure;

@end
