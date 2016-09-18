//
//  UISearchBar+RAC.m
//  XCSDK
//
//  Created by linlin25 on 16/9/13.
//  Copyright © 2016年 zer0. All rights reserved.
//

#import "UISearchBar+RAC.h"
#import <objc/runtime.h>
#import "RACDelegateProxy.h"
#import "NSObject+RACDescription.h"

@interface UISearchBar ()
@end

@implementation UISearchBar (RAC)

static void RACUseDelegateProxy(UISearchBar *self) {
    if (self.delegate == self.rac_delegateProxy) return;
    
    self.rac_delegateProxy.rac_proxiedDelegate = self.delegate;
    self.delegate = (id)self.rac_delegateProxy;
}

- (RACDelegateProxy *)rac_delegateProxy {
    RACDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
    if (proxy == nil) {
        proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UISearchBarDelegate)];
        objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return proxy;
}

- (RACSignal *)rac_textSignal {
    @weakify(self);
    RACSignal *signal = [[[[[RACSignal
                             defer:^{
                                 @strongify(self);
                                 return [RACSignal return:RACTuplePack(self)];
                             }]
                            concat:[self.rac_delegateProxy signalForSelector:@selector(searchBar:textDidChange:)]]
                           reduceEach:^(UISearchBar *searchBar) {
                               return searchBar.text;
                           }]
                          takeUntil:self.rac_willDeallocSignal]
                         setNameWithFormat:@"%@ -rac_textSignal", self.rac_description];
    
    RACUseDelegateProxy(self);
    
    return signal;
}
@end
