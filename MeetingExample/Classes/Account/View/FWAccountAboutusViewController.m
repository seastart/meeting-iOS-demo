//
//  FWAccountAboutusViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWAccountAboutusViewController.h"

@interface FWAccountAboutusViewController ()

/// SDK版本
@property (weak, nonatomic) IBOutlet UILabel *moduleLabel;
/// 应用版本
@property (weak, nonatomic) IBOutlet UILabel *applicationLabel;

@end

@implementation FWAccountAboutusViewController

#pragma mark - 页面开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 显示顶部导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 初始化UI
/// 初始化UI
- (void)buildView {
    
    /// 设置默认数据
    [self setupDefaultData];
}

#pragma mark - 设置默认数据
- (void)setupDefaultData {
    
    /// 设置标题
    self.navigationItem.title = NSLocalizedString(@"关于我们", nil);
    /// 设置SDK版本
    self.moduleLabel.text = [[MeetingKit sharedInstance] version];
    /// 设置应用版本
    self.applicationLabel.text = [NSString stringWithFormat:@"%@(%@)", BundleShortVersion, BundleVersion];
}

@end
