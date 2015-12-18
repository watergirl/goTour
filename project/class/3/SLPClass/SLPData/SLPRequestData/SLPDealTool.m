//
//  SLPDealTool.m
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPDealTool.h"
#import "SLPAPITool.h"

@implementation SLPDealTool

+ (void)findDeals:(SLPFindDealParam *)param success:(void(^)(SLPFindDealResult *result))success failure:(void(^)(NSError *error))failure
{
    [[SLPAPITool sharedAPITool] requestWithURL:@"v1/deal/find_deals" params:param.keyValues success:^(id json) {
        if (success) {
            SLPFindDealResult * obj = [SLPFindDealResult objectWithKeyValues:json];
            success(obj);
        }
    } failure:failure];
}

+ (void)getSingleDeal:(SLPGetSingleDealParam *)param success:(void(^)(SLPGetSingleDealResult *result))success failure:(void(^)(NSError * error))failure
{
    [[SLPAPITool sharedAPITool] requestWithURL:@"v1/deal/get_single_deal" params:param.keyValues success:^(id json) {
        if (success) {
            SLPGetSingleDealResult * obj = [SLPGetSingleDealResult objectWithKeyValues:json];
            success(obj);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)getSingleDealComment:(SLPGetSingleDealCommentParam *)param success:(void(^)(SLPGetSingleDealCommentResult *result))success failure:(void(^)(NSError * error))failure
{
    [[SLPAPITool sharedAPITool] requestWithURL:@"v1/review/get_recent_reviews" params:param.keyValues success:^(id json) {
        if (success) {
            SLPGetSingleDealCommentResult * obj = [SLPGetSingleDealCommentResult objectWithKeyValues:json];
            success(obj);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
