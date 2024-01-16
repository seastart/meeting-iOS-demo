//
//  FWHomeViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWHomeViewController.h"
#import "FWHomeTableViewCell.h"
#import "FWHomeViewModel.h"

/// 列表头部高度
#define kFWHomeTableSectionHeaderViewH 10.0
/// 列表项目高度
#define kFWHomeTableCellHeaderViewH 128.0
/// 列表项目数据
#define kFWHomeItemList @[@{@"type" : @(FWHomeFunctionTypeMetting), @"imageName" : @"icon_home_itembg", @"title" : NSLocalizedString(@"多人音视频房间", nil), @"describe" : NSLocalizedString(@"适用于视频会议", nil)}]

@interface FWHomeViewController ()

/// tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/// ViewModel
@property (strong, nonatomic) FWHomeViewModel *viewModel;

@end

@implementation FWHomeViewController

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
    /// 设置ViewModel
    [self setupViewModel];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置默认数据
- (void)setupDefaultData {
    
    /// 设置标题
    self.navigationItem.title = NSLocalizedString(@"海星音视频", nil);
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWHomeViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    /// @weakify(self);
    
    /// 监听订阅加载状态
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber * _Nullable value) {
        if(value.boolValue) {
            [FWToastBridge showToastAction];
        } else {
            [FWToastBridge hiddenToastAction];
        }
    }];
    
    /// 提示框订阅
    [self.viewModel.toastSubject subscribeNext:^(id _Nullable message) {
        if (!kStringIsEmpty(message)) {
            [FWToastBridge showToastAction:message];
        }
    }];
}

#pragma mark ------- TableView的代理方法 -------
#pragma mark 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return kFWHomeItemList.count;
}

#pragma mark 菜单头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kFWHomeTableSectionHeaderViewH;
}

#pragma mark 自定义分组头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *hIdentifier = @"kFWHomeTableSectionHeaderViewIdentifier";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:hIdentifier];
    if(header == nil) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:hIdentifier];
    }
    header.contentView.backgroundColor = [UIColor clearColor];
    return header;
}

#pragma mark 每个项目高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kFWHomeTableCellHeaderViewH;
}

#pragma mark 初始化项目
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FWHomeTableViewCell *rCell = [FWHomeTableViewCell cellWithTableView:tableView];
    [self configHomeCell:rCell atIndexPath:indexPath];
    return rCell;
}

#pragma mark 设置项目内容
- (void)configHomeCell:(FWHomeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    /// 获取项目数据
    NSDictionary *itemDic = [kFWHomeItemList objectAtIndex:indexPath.row];
    /// 设置项目内容
    [cell setupWithImageName:[itemDic objectForKey:@"imageName"] titleText:[itemDic objectForKey:@"title"] describeText:[itemDic objectForKey:@"describe"]];
}

#pragma mark 项目点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    /// 获取项目数据
    NSDictionary *itemDic = [kFWHomeItemList objectAtIndex:indexPath.row];
    /// 获取项目类型
    FWHomeFunctionType type = (FWHomeFunctionType)[[itemDic objectForKey:@"type"] integerValue];
    /// 处理项目点击事件
    [self handleSelectRowWithType:type];
}

#pragma mark - 处理项目点击事件
/// 处理项目点击事件
/// - Parameter type: 功能类型
- (void)handleSelectRowWithType:(FWHomeFunctionType)type {
    
    switch (type) {
        case FWHomeFunctionTypeMetting:
            /// 跳转房间页面
            [self push:@"FWRoomViewController" block:nil];
            break;
        default:
            break;
    }
}

@end
