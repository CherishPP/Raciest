//
//  UISearchBar+RAC.h
//  XCSDK
//
//  Created by linlin25 on 16/9/13.
//  Copyright © 2016年 zer0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface UISearchBar (RAC)

@property (nonatomic, strong, readonly) RACDelegateProxy *rac_delegateProxy;


- (RACSignal *)rac_textSignal;

@end
