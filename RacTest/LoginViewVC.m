//
//  LoginViewVC.m
//  RacTest
//
//  Created by 高盼盼 on 16/9/12.
//  Copyright © 2016年 高盼盼. All rights reserved.
//

#import "LoginViewVC.h"
#import <PureLayout/PureLayout.h>
#import "LoginViewModel.h"
#import "TableViewController.h"
#import "Test.h"

@interface LoginViewVC ()

@property (nonatomic,strong)UITextField * name;

@property (nonatomic,strong)UITextField * psd;

@property (nonatomic,strong)UIButton * btn;

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic,strong)LoginViewModel * loginViewModel;

@end

@implementation LoginViewVC

- (void)loadView{
    self.view  = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.name];
    [self.view addSubview:self.psd];
    [self.view addSubview:self.btn];
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bindModel];

}

- (void)bindModel{
    // 给模型的属性绑定信号
    // 只要账号文本框一改变，就会给account赋值
    RAC(self.loginViewModel.user,name) = self.name.rac_textSignal;
    RAC(self.loginViewModel.user,psd) = self.psd.rac_textSignal;
    // 绑定登录按钮
    RAC(self.btn,enabled) = self.loginViewModel.enableLoginSig;
    
    //监听登录按钮
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //执行登录操作
        @weakify(self)
        RACSignal * signal = [self.loginViewModel.LoginCommand execute:nil];
        
        [signal subscribeNext:^(id x) {
            @strongify(self)
            if ([x isEqualToString:@"登录成功"]) {
                NSLog(@"登录成功");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //界面跳转
                    TableViewController * table = [[TableViewController alloc] init];
//                    Test* table = [[Test alloc] init];
                    [self.navigationController pushViewController:table animated:YES];
                });
            }

        }];
    }];
}

- (void)updateViewConstraints{
    if (!self.didSetupConstraints) {
        [self.name autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:50];
        [self.name autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:50];
        [self.name autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:150];
        [@[self.name,self.psd,self.btn] autoSetViewsDimension:ALDimensionHeight toSize:50];
        
        [self.psd autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.name];
        [self.psd autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.name];
        [self.psd autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.name withOffset:50];
        
        [self.btn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.name];
        [self.btn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.name];
        [self.btn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.psd withOffset:50];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
    
}

- (LoginViewModel *)loginViewModel{
    if (!_loginViewModel) {
        _loginViewModel = [[LoginViewModel alloc] init];
    }
    return _loginViewModel;
}

- (UITextField *)name{
    if (!_name) {
        _name = [UITextField newAutoLayoutView];
        _name.borderStyle = UITextBorderStyleRoundedRect;
        _name.placeholder = @"用户名";
    }
    return _name;
}

- (UITextField *)psd{
    if (!_psd) {
        _psd = [UITextField newAutoLayoutView];
        _psd.borderStyle = UITextBorderStyleRoundedRect;
        _psd.placeholder = @"密码";
    }
    return _psd;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton newAutoLayoutView];
        [_btn setTitle:@"登录" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    }
    return _btn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
