//
//  MenuTableViewController.m
//  OpenGLESDemo
//
//  Created by iMac on 2018/4/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "MenuTableViewController.h"
#import "ViewController.h"
#import "GLKDemoViewController.h"
#import "GLKColorViewController.h"
#import "LiveViewController.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"DemoList";
    self.tableView.rowHeight = 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = nil;
    
    switch (indexPath.row) {
        case 0:
            vc = [GLKColorViewController new];
            break;
        case 1:
            vc = [GLKDemoViewController new];
            break;
        case 2:
            vc = [LiveViewController new];
            break;
//        case 3:
//            vc = [HJGLKCoordinateViewController new];
//            break;
//        case 4:
//            vc = [HJGLKAnimViewController new];
//            break;
    }
    
    [self.navigationController pushViewController:vc animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    vc.title = cell.textLabel.text;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"ColorDemo";
            break;
        case 1:
            cell.textLabel.text = @"ImageDemo";
            break;
        case 2:
            cell.textLabel.text = @"LiveCapture";
            break;
        case 3:
            cell.textLabel.text = @"HJGLKCoordinate";
            break;
        case 4:
            cell.textLabel.text = @"HJGLKOpenGLAnim";
            break;
    }
    return cell;
}
@end
