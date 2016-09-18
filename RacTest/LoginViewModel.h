//
//  LoginViewModel.h
//  RacTest
//
//  Created by 高盼盼 on 16/9/12.
//  Copyright © 2016年 高盼盼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginViewModel : NSObject

@property (nonatomic,strong)User * user;
//是否允许登录的信号
@property (nonatomic,strong,readonly)RACSignal * enableLoginSig;

@property (nonatomic, strong, readonly) RACCommand *LoginCommand;


@end
