//
//  TableViewController.m
//  RacTest
//
//  Created by 高盼盼 on 16/9/12.
//  Copyright © 2016年 高盼盼. All rights reserved.
//

#import "TableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TableVIewModel.h"
#import "Book.h"
#import "SearchVC.h"


@interface TableViewController ()

@property (nonatomic,strong)TableVIewModel * tableViewModel;

@end

@implementation TableViewController

- (TableVIewModel *)tableViewModel{
    if (!_tableViewModel) {
        _tableViewModel = [[TableVIewModel alloc] init];
    }
    return _tableViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * view = [UIView new];
    self.tableView.tableFooterView = view;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadData];
    
    
}

- (void)loadData{
    //执行请求
    RACSignal * requesrSig = [self.tableViewModel.requestCommand execute:nil];
    //获取请求的数据
    @weakify(self);
    [requesrSig subscribeNext:^(NSArray * x) {
        @strongify(self);
        self.tableViewModel.books = x;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    Book * book = self.tableViewModel.books[indexPath.row];
    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = book.subtitle;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchVC * search = [[SearchVC alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
