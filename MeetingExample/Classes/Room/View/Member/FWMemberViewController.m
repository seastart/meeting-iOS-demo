//
//  FWMemberViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2024/2/4.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMemberAlertViewController.h"
#import "FWMemberViewController.h"
#import "FWMemberTableViewCell.h"
#import "FWMemberViewModel.h"

/// 列表头部高度
#define kFWMemberTableSectionHeaderViewH 10.0
/// 列表项目高度
#define kFWMemberTableCellRowViewH 50.0

@interface FWMemberViewController ()

/// tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 全体音频操作按钮
@property (weak, nonatomic) IBOutlet UIButton *frequencyAllButton;
/// 全体画面操作按钮
@property (weak, nonatomic) IBOutlet UIButton *framesAllButton;

/// ViewModel
@property (strong, nonatomic) FWMemberViewModel *viewModel;

/// 成员列表数据
@property (nonatomic, strong) NSMutableArray <FWRoomMemberModel *> *listDataSource;

@end

@implementation FWMemberViewController

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

#pragma mark - 创建成员列表数据
/// 创建成员列表数据
- (NSMutableArray *)listDataSource {
    
    if (!_listDataSource) {
        _listDataSource = [NSMutableArray arrayWithArray:[FWRoomMemberManager sharedManager].getAllMembers];
    }
    return _listDataSource;
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
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置默认数据
- (void)setupDefaultData {
    
    /// 设置页面标题
    self.navigationItem.title = @"参会成员";
    /// 设置按钮常规样式
    [self normalModality:self.framesAllButton title:@"全体禁画"];
    [self normalModality:self.frequencyAllButton title:@"全体静音"];
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWMemberViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 监听订阅全员静音状态
    [RACObserve(self.viewModel, frequencyAllEnabled) subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        if (value.boolValue) {
            /// 按钮选中样式
            [self selectedModality:self.frequencyAllButton title:@"解除全体静音"];
        } else {
            /// 按钮常规样式
            [self normalModality:self.frequencyAllButton title:@"全体静音"];
        }
    }];
    
    /// 监听订阅全员禁画状态
    [RACObserve(self.viewModel, framesAllEnabled) subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        if (value.boolValue) {
            /// 按钮选中样式
            [self selectedModality:self.framesAllButton title:@"解除全体禁画"];
        } else {
            /// 按钮常规样式
            [self normalModality:self.framesAllButton title:@"全体禁画"];
        }
    }];
    
    /// 绑定全体音频操作按钮事件
    [[self.frequencyAllButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        if (self.viewModel.frequencyAllEnabled) {
            /// 解除房间全体禁音
            [self presentUnchainRoomFrequencyAlert];
        } else {
            /// 房间全体禁音
            [self presentRoomFrequencyAlert];
        }
    }];
    
    /// 绑定全体画面操作按钮事件
    [[self.framesAllButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        if (self.viewModel.framesAllEnabled) {
            /// 解除房间全体禁画
            [self presentUnchainRoomFramesAlert];
        } else {
            /// 房间全体禁画
            [self presentRoomFramesAlert];
        }
    }];
    
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

#pragma mark - 按钮常规样式
/// 按钮常规样式
/// - Parameter sender: 按钮实例
/// - Parameter title: 按钮标题
- (void)normalModality:(UIButton *)sender title:(NSString *)title {
    
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitleColor:RGBOF(0x999999) forState:UIControlStateNormal];
    sender.layer.borderWidth = 0.5f;
    sender.layer.borderColor = RGBOF(0xC5CAD5).CGColor;
}

#pragma mark - 按钮选中样式
/// 按钮选中样式
/// - Parameter sender: 按钮实例
/// - Parameter title: 按钮标题
- (void)selectedModality:(UIButton *)sender title:(NSString *)title {
    
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitleColor:RGBOF(0xFF4B51) forState:UIControlStateNormal];
    sender.layer.borderWidth = 0.5f;
    sender.layer.borderColor = RGBOF(0xFF4B51).CGColor;
}

#pragma mark - 房间全体禁音
/// 房间全体禁音
- (void)presentRoomFrequencyAlert {
    
    @weakify(self);
    
    FWMemberAlertViewController *alertVC = [FWMemberAlertViewController alertControllerWithTitle:@"所有以及新加入的成员将被静音" message:@"允许成员自我解除静音" cancelTitle:@"取消" ensureTitle:@"全体静音" cancelBlock:nil ensureBlock:^(BOOL selected) {
        @strongify(self);
        /// 设置状态
        self.viewModel.frequencyAllEnabled = YES;
        /// 弹出提示信息
        [FWToastBridge showToastAction:[NSString stringWithFormat:@"已开启全体静音，%@", selected ? @"允许成员自行解除" : @"不允许成员自行解除"]];
    }];
    [self presentViewController:alertVC animated:NO completion:nil];
}

#pragma mark - 解除房间全体禁音
/// 解除房间全体禁音
- (void)presentUnchainRoomFrequencyAlert {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定解除全体静音吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 设置状态
        self.viewModel.frequencyAllEnabled = NO;
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 房间全体禁画
/// 房间全体禁画
- (void)presentRoomFramesAlert {
    
    @weakify(self);
    
    FWMemberAlertViewController *alertVC = [FWMemberAlertViewController alertControllerWithTitle:@"所有以及新加入的成员将被禁画" message:@"允许成员自我开启视频" cancelTitle:@"取消" ensureTitle:@"全体禁画" cancelBlock:nil ensureBlock:^(BOOL selected) {
        @strongify(self);
        /// 设置状态
        self.viewModel.framesAllEnabled = YES;
        /// 弹出提示信息
        [FWToastBridge showToastAction:[NSString stringWithFormat:@"已开启全体禁画，%@", selected ? @"允许成员自行解除" : @"不允许成员自行解除"]];
    }];
    [self presentViewController:alertVC animated:NO completion:nil];
}

#pragma mark - 解除房间全体禁画
/// 解除房间全体禁画
- (void)presentUnchainRoomFramesAlert {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定解除全体禁画吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 设置状态
        self.viewModel.framesAllEnabled = NO;
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark ------- TableView的代理方法 -------
#pragma mark 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

#pragma mark 菜单头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kFWMemberTableSectionHeaderViewH;
}

#pragma mark 自定义分组头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *hIdentifier = @"kFWMemberTableSectionHeaderViewIdentifier";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:hIdentifier];
    if(header == nil) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:hIdentifier];
    }
    header.contentView.backgroundColor = [UIColor clearColor];
    return header;
}

#pragma mark 每个项目高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kFWMemberTableCellRowViewH;
}

#pragma mark 初始化项目
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FWMemberTableViewCell *rCell = [FWMemberTableViewCell cellWithTableView:tableView];
    [self configHMemberCell:rCell atIndexPath:indexPath];
    return rCell;
}

#pragma mark 设置项目内容
- (void)configHMemberCell:(FWMemberTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *nickname = @"抹茶玛奇哚";
    BOOL isOwner = YES;
    BOOL oneself = YES;
    BOOL videoState = YES;
    BOOL audioState = YES;
    if (indexPath.row == 0) {
        nickname = @"抹茶玛奇哚";
        isOwner = YES;
        oneself = YES;
        videoState = YES;
        audioState = YES;
    } else if (indexPath.row == 1) {
        nickname = @"蜡笔小生";
        isOwner = YES;
        oneself = NO;
        videoState = NO;
        audioState = NO;
    } else if (indexPath.row == 2) {
        nickname = @"可可西里没有海";
        isOwner = NO;
        oneself = NO;
        videoState = NO;
        audioState = YES;
    } else {
        nickname = @"加德满都";
        isOwner = NO;
        oneself = NO;
        videoState = YES;
        audioState = NO;
    }
    
    @weakify(self);
    /// 设置项目内容
    [cell setupWithAvatarUrl:@"" nicknameText:nickname isOwner:isOwner oneself:oneself videoState:videoState audioState:audioState removeBlock:^(NSString * _Nonnull nickname) {
        @strongify(self);
        /// 移除成员确认弹窗
        [self presentRoomKickoutAlert:nickname];
    }];
}

#pragma mark 项目点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 移除成员确认弹窗
/// 移除成员确认弹窗
/// @param nickname 成员昵称
- (void)presentRoomKickoutAlert:(NSString *)nickname {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您确定要移出“%@”吗？", nickname] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 弹出提示信息
        [FWToastBridge showToastAction:@"移除成员成功"];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
