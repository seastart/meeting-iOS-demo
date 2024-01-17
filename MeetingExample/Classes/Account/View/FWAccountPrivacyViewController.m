//
//  FWAccountPrivacyViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWAccountPrivacyViewController.h"
#import "FWAccountPrivacyTableViewCell.h"

/// 列表头部高度
#define kFWAccountPrivacySectionHeaderViewH 10.0
/// 列表项目高度
#define kFWAccountPrivacyTableCellRowViewH 50.0
/// 列表项目数据
#define kFWAccountPrivacyItemList @[@{@"type" : @(FWAccountWebTypePersonal), @"title" : NSLocalizedString(@"个人信息收集清单", nil)}, @{@"type" : @(FWAccountWebTypeThirdParty), @"title" : NSLocalizedString(@"第三方信息共享清单", nil)}, @{@"type" : @(FWAccountWebTypeAgreement), @"title" : NSLocalizedString(@"用户协议", nil)}, @{@"type" : @(FWAccountWebTypePrivacy), @"title" : NSLocalizedString(@"隐私协议", nil)}]

@interface FWAccountPrivacyViewController ()

/// tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FWAccountPrivacyViewController

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
    self.navigationItem.title = NSLocalizedString(@"隐私", nil);
}

#pragma mark ------- TableView的代理方法 -------
#pragma mark 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return kFWAccountPrivacyItemList.count;
}

#pragma mark 菜单头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kFWAccountPrivacySectionHeaderViewH;
}

#pragma mark 自定义分组头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *hIdentifier = @"kFWAccountPrivacySectionHeaderViewIdentifier";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:hIdentifier];
    if(header == nil) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:hIdentifier];
    }
    header.contentView.backgroundColor = [UIColor clearColor];
    return header;
}

#pragma mark 每个项目高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kFWAccountPrivacyTableCellRowViewH;
}

#pragma mark 初始化项目
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FWAccountPrivacyTableViewCell *rCell = [FWAccountPrivacyTableViewCell cellWithTableView:tableView];
    [self configAccountPrivacyCell:rCell atIndexPath:indexPath];
    return rCell;
}

#pragma mark 设置项目内容
- (void)configAccountPrivacyCell:(FWAccountPrivacyTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    /// 获取项目数据
    NSDictionary *itemDic = [kFWAccountPrivacyItemList objectAtIndex:indexPath.row];
    /// 设置项目内容
    [cell setupWithTitleText:[itemDic objectForKey:@"title"]];
}

#pragma mark 项目点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    /// 获取项目数据
    NSDictionary *itemDic = [kFWAccountPrivacyItemList objectAtIndex:indexPath.row];
    /// 获取项目类型
    FWAccountWebType type = (FWAccountWebType)[[itemDic objectForKey:@"type"] integerValue];
    /// 处理项目点击事件
    [self handleSelectRowWithType:type];
}

#pragma mark - 处理项目点击事件
/// 处理项目点击事件
/// - Parameter type: 功能类型
- (void)handleSelectRowWithType:(FWAccountWebType)type {
    
    /// 跳转网页加载页面
    [self push:@"FWAccountWebKitViewController" info:nil tag:type block:nil];
}

@end
