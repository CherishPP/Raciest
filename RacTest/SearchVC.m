//
//  SearchVC.m
//  RacTest
//
//  Created by 高盼盼 on 16/9/18.
//  Copyright © 2016年 高盼盼. All rights reserved.
//

#import "SearchVC.h"
#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SearchVC ()<UISearchBarDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITextField * search;
@property (nonatomic,strong) UISearchBar * searchBar;

@end

@implementation SearchVC

- (void)loadView{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.search];
    [self.view addSubview:self.searchBar];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints{
    if (!_didSetupConstraints) {
        [self.search autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:150];
        [@[self.searchBar,self.search] autoSetViewsDimensionsToSize:CGSizeMake(200, 50)];
        [self.search autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        [self.searchBar autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.search withOffset:50];
        [self.searchBar autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //throttle截流，在0.3秒之内，只允许通过一次信号
    //switchToLatest用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。
    [[[[[[self.search.rac_textSignal throttle:0.3] distinctUntilChanged] ignore:@""] map:^id(id value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"请求:%@",value);
            [subscriber sendNext:value];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                //请求
            }];
        }];
    }] switchToLatest] subscribeNext:^(id x) {
        
    }];
    
    
    
    self.searchBar.delegate = self;
}

- (UITextField *)search{
    if (!_search) {
        _search = [UITextField newAutoLayoutView];
        _search.borderStyle = UITextBorderStyleRoundedRect;
        _search.placeholder = @"点击搜索";
        _search.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _search;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [UISearchBar newAutoLayoutView];
        _searchBar.placeholder = @"搜索";
    }
    return _searchBar;
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
