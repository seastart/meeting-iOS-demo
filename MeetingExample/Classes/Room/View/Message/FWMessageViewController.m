//
//  FWMessageViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2024/2/2.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMessageViewController.h"
#import "FWMessageTableViewCell.h"
#import "FWMessageMineTableViewCell.h"
#import "FWMessageTableSectionHeaderView.h"
#import "FWMessageViewModel.h"

#define FWMessageTableSectionHeaderViewH 40.0
/// 定义一个重用标识
static NSString *FWMessageTableSectionHeaderViewIdentifier = @"FWMessageTableSectionHeaderViewIdentifier";

@interface FWMessageViewController ()

/// 列表视图
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 输入框组件
@property (weak, nonatomic) IBOutlet UIView *inputView;
/// 输入框组件底部距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomMargin;
/// 消息输入框
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
/// 发送按钮
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

/// ViewModel
@property (strong, nonatomic) FWMessageViewModel *viewModel;

@end

@implementation FWMessageViewController

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 显示顶部导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 页面即将消失
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    /// 隐藏顶部导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 页面开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 初始化UI
/// 初始化UI
- (void)buildView {
    
    /// 设置默认数据
    [self setupDefaultData];
    /// 设置ViewModel
    [self setupViewModel];
    /// 绑定键盘信号
    [self bindKeyboardSignal];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置默认数据
- (void)setupDefaultData {
    
    /// 设置页面标题
    self.navigationItem.title = @"聊天";
    /// 设置输入框占位符
    self.contentTextView.placeHolder = @"聊点什么…";
    /// 预估Cell高度
    self.tableView.estimatedRowHeight = 60.f;
    /// Cell自动尺寸
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    /// 列表滚动到底部
    [self scrollBottomWithAnimated:YES];
}

#pragma mark - 绑定键盘信号
- (void)bindKeyboardSignal {
    
    /// 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    /// 监听键盘收回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWMessageViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 监听消息内容
    [self.contentTextView.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.contentText = text;
    }];
    
    /// 监听订阅加载状态
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber * _Nullable value) {
        if(value.boolValue) {
            [SVProgressHUD show];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
    
    /// 提示框订阅
    [self.viewModel.toastSubject subscribeNext:^(id _Nullable message) {
        if (!kStringIsEmpty(message)) {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
    
    /// 发送消息订阅
    [self.viewModel.sendSubject subscribeNext:^(id _Nullable value) {
        @strongify(self);
        /// 置空内容以及输入框数据
        self.contentTextView.text = nil;
        self.viewModel.contentText = nil;
        /// [self.contentTextView resignFirstResponder];
    }];
    
    /// 绑定发送按钮事件
    [[self.sendButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 发送消息事件
        [self.viewModel onSendEvent];
        /// 发送自定义消息事件
        /// [self.viewModel onSendCustomEvent];
    }];
    
    /// 绑定刷新数据回调
    [[FWMessageManager sharedManager] reloadDataBlock:^{
        @strongify(self);
        /// 刷新聊天列表
        [self.tableView reloadData];
        /// 列表滚动到底部
        [self scrollBottomWithAnimated:YES];
    }];
    
    /// 当前用户聊天禁用状态变更回调
    [[FWRoomMemberManager sharedManager] userChatDisabledChangedBlock:^(BOOL chatDisabled) {
        @strongify(self);
        /// 如果用户聊天状态被禁用
        if (chatDisabled) {
            /// 离开聊天页面
            [self pop:1];
            /// 主持人禁用聊天状态提示弹窗
            [self adminChatDisabledAlert:@"您的聊天状态已被主持人禁用。"];
        }
    }];
    
    /// 当前房间聊天禁用状态变更回调
    [[FWRoomMemberManager sharedManager] roomChatDisabledChangedBlock:^(BOOL chatDisabled) {
        @strongify(self);
        /// 如果房间聊天状态被禁用
        if (chatDisabled) {
            /// 离开聊天页面
            [self pop:1];
            /// 主持人禁用聊天状态提示弹窗
            [self adminChatDisabledAlert:@"房间的聊天状态已被主持人禁用。"];
        }
    }];
}

#pragma mark - 主持人禁用聊天状态提示弹窗
/// 主持人禁用聊天状态提示弹窗
/// - Parameter message: 弹窗描述
- (void)adminChatDisabledAlert:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    [[FWEntryBridge sharedManager].appDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 键盘弹出通知
/// 键盘弹出通知
/// - Parameter notification: 通知对象
- (void)keyboardWillAppear:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    /// 取得键盘的尺寸
    CGSize size = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    /// 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    /// double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    /// 将视图上移计算好的偏移
    [UIView animateWithDuration:0.25 animations:^{
        /// 设置底部边距
        self.inputViewBottomMargin.constant = size.height - SafeBarMottomHeight;
        /// 列表滚动到底部
        [self scrollBottomWithAnimated:YES];
    }];
}

#pragma mark - 键盘收回通知
/// 键盘收回通知
/// - Parameter notification: 通知对象
- (void)keyboardWillDisappear:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.25 animations:^{
        /// 设置底部边距
        self.inputViewBottomMargin.constant = 0.f;
    }];
}

#pragma mark - 列表滚动到底部
/// 列表滚动到底部
/// @param Animated 是否需要动画
- (void)scrollBottomWithAnimated:(BOOL)Animated {
    
    /// 聊天消息为空
    if (kArrayIsEmpty([FWMessageManager sharedManager].getAllChats)) {
        /// 丢弃该指令
        return;
    }
    /// 获取分组数
    NSInteger section = [[FWMessageManager sharedManager] numberOfSectionsInTableView];
    /// 获取该分组行数
    NSInteger row = [[FWMessageManager sharedManager] numberOfRowsInSection:(section - 1)];
    /// 延迟滚动到指定分组
    FWDispatchAfter((int64_t)(0.1 * NSEC_PER_SEC), ^{
        /// 构建索引路径
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(row - 1) inSection:(section - 1)];
        /// 滚动到指定索引路径
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:Animated];
    });
}

#pragma mark - -------------- TableView的代理方法 ---------------
#pragma mark 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[FWMessageManager sharedManager] numberOfSectionsInTableView];
}

#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[FWMessageManager sharedManager] numberOfRowsInSection:section];
}

#pragma mark 菜单头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    /// 聊天消息为空
    if (kArrayIsEmpty([FWMessageManager sharedManager].getAllChats)) {
        return 0.01;
    }
    return FWMessageTableSectionHeaderViewH;
}

#pragma mark 菜单脚部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

#pragma mark 自定义分组头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    /// 聊天消息为空
    if (kArrayIsEmpty([FWMessageManager sharedManager].getAllChats)) {
        return nil;
    }
    FWMessageTableSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FWMessageTableSectionHeaderViewIdentifier];
    if(header == nil) {
        header = [[FWMessageTableSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.sa_width, FWMessageTableSectionHeaderViewH)];
    }
    /// 设置显示信息
    [header setupTitleText:[[FWMessageManager sharedManager] viewForHeaderInSection:section]];
    return header;
}

#pragma mark 初始化Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FWMessageItemModel *itemModel = [[FWMessageManager sharedManager] cellForRowAtIndexPath:indexPath];
    /// 也可约定action用于区分不同的消息类型
    if (itemModel.isMine) {
        FWMessageMineTableViewCell *rCell = [FWMessageMineTableViewCell cellWithTableView:tableView];
        [self configMessageChatMineCell:rCell atItemModel:itemModel];
        return rCell;
    } else {
        FWMessageTableViewCell *rCell = [FWMessageTableViewCell cellWithTableView:tableView];
        [self configMessageChatCell:rCell atItemModel:itemModel];
        return rCell;
    }
}

#pragma mark 设置Cell内容(发送的消息)
- (void)configMessageChatMineCell:(FWMessageMineTableViewCell *)cell atItemModel:(FWMessageItemModel *)itemModel {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupConfig:itemModel.name messageText:itemModel.content avatarUrl:itemModel.avatar];
}

#pragma mark 设置Cell内容(接收的消息)
- (void)configMessageChatCell:(FWMessageTableViewCell *)cell atItemModel:(FWMessageItemModel *)itemModel {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupConfig:itemModel.name messageText:itemModel.content avatarUrl:itemModel.avatar];
}

#pragma mark Cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
