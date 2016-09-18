//
//  Test.m
//  
//
//  Created by 高盼盼 on 16/9/13.
//
//

#import "Test.h"
#import "UISearchBar+RAC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface Test ()<UISearchBarDelegate>

@end

@implementation Test

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UISearchBar * bar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 101, 100, 20)];
    
    [self.view addSubview:bar];
    [[[RACSignal merge:@[bar.rac_textSignal, RACObserve(bar, text)]]throttle:0.5] subscribeNext:^(NSString* text) {
        if ([text length]) {
            NSLog(@"1111111");
            bar.delegate = self;
        }
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"oooooo");
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
