//
//  TableVIewModel.m
//  RacTest
//
//  Created by 高盼盼 on 16/9/13.
//  Copyright © 2016年 高盼盼. All rights reserved.
//

#import "TableVIewModel.h"
#import "MBProgressHUD+PP.h"
#import <AFNetworking.h>
#import "Book.h"

@implementation TableVIewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialBind];
    }
    return self;
}

- (void)initialBind{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal * requestSig = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [MBProgressHUD showAutoMessage:@"数据正在加载"];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"q"] = @"基础";
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
            [manager GET:@"https://api.douban.com/v2/book/search" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                [MBProgressHUD showSuccess:@"成功" ToView:nil];
                [MBProgressHUD hideHUD];
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [MBProgressHUD hideHUD];
                [subscriber sendError:error];
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] ToView:nil];
        
            }];
            return nil;
        }];
        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
        return [requestSig map:^id(NSDictionary * value) {
            NSMutableArray * dictArr = value[@"books"];
            // 字典转模型，遍历字典中的所有元素，全部映射成模型，并且生成数组
            NSArray *modelArr = [[dictArr.rac_sequence map:^id(id value) {
                
                return [Book mj_objectWithKeyValues:value];
            }] array];
            
            return modelArr;
        }];
    }];
}

@end
