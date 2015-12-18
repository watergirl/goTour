//
//  APITool.m
//  project
//
//  Created by lanou3g on 15/10/24.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SLPAPITool.h"
#import "DPAPI.h"

@interface SLPAPITool ()<DPRequestDelegate>

@property (nonatomic, strong)DPAPI * api;

@end

@implementation SLPAPITool

static id _data = nil;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _data = [super allocWithZone:zone];
    });
    return _data;
}
+ (instancetype)sharedAPITool
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _data = [[self  alloc] init];
    });
    return _data;
}
- (id)copyWithZone:(NSZone *)zone
{
    return _data;
}

-(DPAPI *)api
{
    if (_api == nil) {
        self.api = [[DPAPI alloc] init];
    }
    return _api;
}


- (void)requestWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    DPRequest * request = [self.api requestWithURL:url params:[NSMutableDictionary dictionaryWithDictionary:params] delegate:self];
    request.success = success;
    request.failure = failure;

}

#pragma mark DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request.success) {
        request.success(result);
    }
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
//    NSLog(@"请求失败%@",error);
    if (request.failure) {
        request.failure(error);
    }
}



@end
