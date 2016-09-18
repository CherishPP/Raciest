//
//  ViewController.m
//  RacTest
//
//  Created by 高盼盼 on 16/9/12.
//  Copyright © 2016年 高盼盼. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()<UISearchBarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self textFiledObserve];
    [self searchBarObserver];
}

- (void)searchBarObserver{
    UISearchBar * search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    search.delegate = self;
    [self.view addSubview:search];
    [[self rac_signalForSelector:@selector(searchBar:textDidChange:) fromProtocol:@protocol(UISearchBarDelegate)] subscribeNext:^(RACTuple * x) {
        NSLog(@"%@",x.first);
    }];
}

- (void)textFiledObserve{

    UITextField * name = [[UITextField alloc] initWithFrame:CGRectMake(50, 50, 200, 50)];
    name.borderStyle = UITextBorderStyleRoundedRect;
    UITextField * psd = [[UITextField alloc] initWithFrame:CGRectMake(50, 150, 200, 50)];
    psd.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:name];
    [self.view addSubview:psd];
    
#if 0
    [[name rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(UITextField * x) {
        
        NSLog(@"name:%@",x.text);
    }];
    
    [[name.rac_textSignal map:^id(NSString * inputText) {
        return @(inputText.length);
    }] subscribeNext:^(id x) {
        NSLog(@"name的长度:k%@",x);
    }];
    
    
    
    [[psd.rac_textSignal filter:^BOOL(NSString * inputText) {
        return @(inputText.length);
    }] subscribeNext:^(id x) {
        NSLog(@"psd:%@",x);
    }];
#endif
    
    //最简方法
        [name.rac_textSignal subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    
        [[[[[name.rac_textSignal
            distinctUntilChanged]
            //这次和上次信号不一样，才会发送,
            //注：用于刷新页面，当数据不一样才刷新
            delay:1]
            //延迟1秒接收到信号
            ignore:@"1"]
            //忽略“1”的信号发送
            filter:^BOOL(NSString* text) {
            //过滤事件，只允许长度大于2发信号
            //每次信号发出，会先执行过滤条件判断.
            return text.length > 2;
        }] subscribeNext:^(id x) {
            //接收订阅的信号
            //Tip: id x -> NSString * text
            NSLog(@"当前字符串:%@",x);
        }] ;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
