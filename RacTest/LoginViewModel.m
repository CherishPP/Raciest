//
//  LoginViewModel.m
//  RacTest
//
//  Created by 高盼盼 on 16/9/12.
//  Copyright © 2016年 高盼盼. All rights reserved.
//

#import "LoginViewModel.h"
#import "MBProgressHUD+PP.h"

@implementation LoginViewModel


- (User *)user{
    if (!_user) {
        _user = [[User alloc] init];
    }
    return _user;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initialBind];
    }
    return self;
}

- (void)initialBind{
    // 监听账号的属性值改变，把他们聚合成一个信号。如果账号和密码都不为空，则为YES
    _enableLoginSig = [RACSignal combineLatest:@[RACObserve(self.user, name),RACObserve(self.user, psd)] reduce:^id(NSString * name,NSString * psd){
        return @(name.length&&psd.length);
    }];
    
    //处理登录业务逻辑
    _LoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"点击登录");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 模仿网络延迟,真实场景是网络请求
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [subscriber sendNext:@"登录成功"];
                
                // 数据传送完毕，必须调用完成，否则命令永远处于执行状态
                [subscriber sendCompleted];
            });
            
            return nil;
        }];
    }];
    
    //监听登录状态，跳过第一个信号
    [[_LoginCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x isEqualToNumber:@(YES)]) {
            
            // 正在登录ing...
            [MBProgressHUD showAutoMessage:@"正在登录..."];
            
        }else
        {
            // 登录成功
            [MBProgressHUD hideHUD];
           
        }
    }];
}

@end
