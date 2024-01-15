//
//  FWAccountViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/15.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWAccountViewController.h"

@interface FWAccountViewController ()

@end

@implementation FWAccountViewController

#pragma mark - 页面开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    /// [self buildView];
}

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 显示顶部导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 退出登录对话框
/// 退出登录对话框
- (void)logoutAlert {
    
    @weakify(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 销毁用户信息
        [[FWStoreDataBridge sharedManager] logout];
        /// 退出登录事件
//        [self.viewModel onLogoutEvent];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
