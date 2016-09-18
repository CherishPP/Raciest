//
//  TableVIewModel.h
//  RacTest
//
//  Created by 高盼盼 on 16/9/13.
//  Copyright © 2016年 高盼盼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TableVIewModel : NSObject

@property (nonatomic,strong,readonly) RACCommand * requestCommand;
@property (nonatomic,strong) NSArray * books;

@end
