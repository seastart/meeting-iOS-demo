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
/// 底部工具栏
@property (weak, nonatomic) IBOutlet UIView *toolView;
/// 底部工具边距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBottomConstraint;
/// 全体音频操作按钮
@property (weak, nonatomic) IBOutlet UIButton *frequencyAllButton;
/// 解除全体音频操作按钮
@property (weak, nonatomic) IBOutlet UIButton *unchainFrequencyAllButton;
/// 全体画面操作按钮
@property (weak, nonatomic) IBOutlet UIButton *framesAllButton;
/// 解除全体画面操作按钮
@property (weak, nonatomic) IBOutlet UIButton *unchainFramesAllButton;

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
- (NSMutableArray <FWRoomMemberModel *> *)listDataSource {
    
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
/// 设置默认数据
- (void)setupDefaultData {
    
    /// 设置页面标题
    self.navigationItem.title = @"参会成员";
    /// 设置按钮常规样式
    [self normalModality:self.framesAllButton title:@"全体禁画"];
    [self normalModality:self.unchainFramesAllButton title:@"解除全体禁画"];
    [self normalModality:self.frequencyAllButton title:@"全体静音"];
    [self normalModality:self.unchainFrequencyAllButton title:@"解除全体静音"];
    /// 声明底部边距
    CGFloat bottomMargin = 0.0;
    /// 声明显示状态
    BOOL hidden = YES;
    /// 根据当前用户角色设置边距以及显示状态
    if ([[FWRoomMemberManager sharedManager] getUserRole] == SEAUserRoleNormal) {
        hidden = YES;
        bottomMargin = 0.0;
    } else {
        hidden = NO;
        bottomMargin = 60.0;
    }
    /// 设置底部工具条显示状态
    self.toolView.hidden = hidden;
    /// 设置底部工具条底部边距
    self.toolBottomConstraint.constant = bottomMargin;
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
    
    /// 绑定全体音频操作按钮事件
    [[self.frequencyAllButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 房间全体禁音
        [self presentRoomFrequencyAlert];
    }];
    
    /// 绑定解除全体音频操作按钮事件
    [[self.unchainFrequencyAllButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 解除房间全体禁音
        [self presentUnchainRoomFrequencyAlert];
    }];
    
    /// 绑定全体画面操作按钮事件
    [[self.framesAllButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 房间全体禁画
        [self presentRoomFramesAlert];
    }];
    
    /// 绑定解除全体画面操作按钮事件
    [[self.unchainFramesAllButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 解除房间全体禁画
        [self presentUnchainRoomFramesAlert];
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
    
    /// 操作成功订阅
    [self.viewModel.succeedSubject subscribeNext:^(id _Nullable message) {
        if (!kStringIsEmpty(message)) {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
    
    /// 刷新成员列表回调
    [[FWRoomMemberManager sharedManager] reloadBlock:^{
        @strongify(self);
        /// 刷新成员列表
        [self reloadMemberLists];
    }];
    
    /// 当前角色变更回调
    [[FWRoomMemberManager sharedManager] roleChangedBlock:^{
        @strongify(self);
        /// 重新设置默认数据
        [self setupDefaultData];
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
        /// 设置全体静音状态
        [self.viewModel setRoomFrequencyState:YES selfUnmuteMicDisabled:!selected];
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
        /// 设置全体静音状态
        [self.viewModel setRoomFrequencyState:NO selfUnmuteMicDisabled:NO];
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
        /// 设置全体禁画状态
        [self.viewModel setRoomFramesState:YES selfUnmuteCameraDisabled:!selected];
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
        /// 设置全体禁画状态
        [self.viewModel setRoomFramesState:NO selfUnmuteCameraDisabled:NO];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 刷新成员列表
/// 刷新成员列表
- (void)reloadMemberLists {
    
    [self.listDataSource removeAllObjects];
    [self.listDataSource addObjectsFromArray:[FWRoomMemberManager sharedManager].getAllMembers];
    [self.tableView reloadData];
}

#pragma mark ------- TableView的代理方法 -------
#pragma mark 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listDataSource.count;
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
    /// 获取目标成员
    FWRoomMemberModel *memberModel = [self.listDataSource objectAtIndex:indexPath.row];
    /// 获取用户数据
    SEAUserModel *userModel = [[MeetingKit sharedInstance] findMemberWithUserId:memberModel.userId];
    /// 获取用户昵称
    NSString *nickname = userModel.name;
    /// 获取用户是否为主持人
    BOOL isOwner = (userModel.extend.role != SEAUserRoleNormal);
    /// 获取用户是否为当前成员
    BOOL isMine = memberModel.isMine;
    /// 获取用户视频状态
    BOOL videoState = (userModel.extend.cameraState == SEADeviceStateOpen);
    /// 获取用户音频状态
    BOOL audioState = (userModel.extend.micState == SEADeviceStateOpen);
    /// 声明弱引用
    @weakify(self);
    /// 设置项目内容
    [cell setupWithUserId:userModel.userId avatarUrl:userModel.extend.avatar nicknameText:nickname isOwner:isOwner isMine:isMine videoState:videoState audioState:audioState index:indexPath.row microphoneBlock:^(NSInteger index) {
        @strongify(self);
        /// 成员麦克风被选中事件
        [self didSelectRowAtMemberMicrophone:index];
    } cameraBlock:^(NSInteger index) {
        @strongify(self);
        /// 成员摄像头被选中事件
        [self didSelectRowAtMemberCamera:index];
    } removeBlock:^(NSString * _Nonnull userId, NSString * _Nonnull nickname) {
        @strongify(self);
        /// 移除成员确认弹窗
        [self presentRoomKickoutAlert:userId nickname:nickname];
    }];
}

#pragma mark 项目点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    /// 获取目标成员
    /// FWRoomMemberModel *memberModel = [self.listDataSource objectAtIndex:indexPath.row];
    /// 成员被选中事件
    /// [self didSelectRowAtMemberModel:memberModel];
}

#pragma mark - 成员麦克风被选中事件
/// 成员麦克风被选中事件
/// @param index 成员索引
- (void)didSelectRowAtMemberMicrophone:(NSInteger)index {
    
    /// 获取目标成员数据
    FWRoomMemberModel *memberModel = [self.listDataSource objectAtIndex:index];
    /// 获取当前账户数据
    SEAUserModel *userModel = [[MeetingKit sharedInstance] getMySelf];
    
    if (memberModel.isMine) {
        /// 成员选中自己的麦克风
        [self didSelectMineMicrophone:userModel];
    } else {
        /// 当前用户不为普通成员
        if (userModel.extend.role != SEAUserRoleNormal) {
            /// 主持人选中成员的麦克风
            [self didSelectMemberMicrophone:memberModel.userId];
        }
    }
}

#pragma mark - 成员选中自己的麦克风
/// 成员选中自己的麦克风
/// - Parameter userModel: 当前账户数据
- (void)didSelectMineMicrophone:(SEAUserModel *)userModel {
    
    /// 获取当前麦克风状态
    BOOL microphoneState = (userModel.extend.micState == SEADeviceStateOpen);
    /// 根据当前状态发起请求
    if (microphoneState) {
        /// 发送请求关闭麦克风通知
        [[NSNotificationCenter defaultCenter] postNotificationName:FWMeetingQueryCloseMicrophoneNotification object:nil];
    } else {
        /// 发送请求开启麦克风通知
        [[NSNotificationCenter defaultCenter] postNotificationName:FWMeetingQueryOpenMicrophoneNotification object:nil];
    }
}

#pragma mark - 主持人选中成员的麦克风
/// 主持人选中成员的麦克风
/// - Parameter userId: 成员标识
- (void)didSelectMemberMicrophone:(NSString *)userId {
    
    /// 获取用户数据
    SEAUserModel *userModel = [[MeetingKit sharedInstance] findMemberWithUserId:userId];
    /// 获取用户当前麦克风状态
    BOOL microphoneState = (userModel.extend.micState == SEADeviceStateOpen);
    /// 根据当前状态发起请求
    if (microphoneState) {
        /// 关闭远端用户麦克风
        [self.viewModel adminCloseUserMic:userId nickname:userModel.name];
    } else {
        /// 请求打开远端用户麦克风
        @weakify(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您确定要请求“%@”开启麦克风吗？", userModel.name] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        }];
        UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            @strongify(self);
            /// 请求打开成员麦克风
            [self.viewModel adminRequestUserOpenMic:userId nickname:userModel.name];
        }];
        [alert addAction:cancelAction];
        [alert addAction:ensureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 成员摄像头被选中事件
/// 成员摄像头被选中事件
/// @param index 成员索引
- (void)didSelectRowAtMemberCamera:(NSInteger)index {
    
    /// 获取目标成员数据
    FWRoomMemberModel *memberModel = [self.listDataSource objectAtIndex:index];
    /// 获取当前账户数据
    SEAUserModel *userModel = [[MeetingKit sharedInstance] getMySelf];
    
    if (memberModel.isMine) {
        /// 成员选中自己的摄像头
        [self didSelectMineCamera:userModel];
    } else {
        /// 当前用户不为普通成员
        if (userModel.extend.role != SEAUserRoleNormal) {
            /// 主持人选中成员的摄像头
            [self didSelectMemberCamera:memberModel.userId];
        }
    }
}

#pragma mark - 成员选中自己的摄像头
/// 成员选中自己的摄像头
/// - Parameter userModel: 当前账户数据
- (void)didSelectMineCamera:(SEAUserModel *)userModel {
    
    /// 获取当前摄像头状态
    BOOL cameraState = (userModel.extend.cameraState == SEADeviceStateOpen);
    /// 根据当前状态发起请求
    if (cameraState) {
        /// 发送请求关闭摄像头通知
        [[NSNotificationCenter defaultCenter] postNotificationName:FWMeetingQueryCloseCameraNotification object:nil];
    } else {
        /// 发送请求开启摄像头通知
        [[NSNotificationCenter defaultCenter] postNotificationName:FWMeetingQueryOpenCameraNotification object:nil];
    }
}

#pragma mark - 主持人选中成员的摄像头
/// 主持人选中成员的摄像头
/// - Parameter userId: 成员标识
- (void)didSelectMemberCamera:(NSString *)userId {
    
    /// 获取用户数据
    SEAUserModel *userModel = [[MeetingKit sharedInstance] findMemberWithUserId:userId];
    /// 获取用户当前摄像头状态
    BOOL cameraState = (userModel.extend.cameraState == SEADeviceStateOpen);
    /// 根据当前状态发起请求
    if (cameraState) {
        /// 关闭远端用户摄像头
        [self.viewModel adminCloseUserCamera:userId nickname:userModel.name];
    } else {
        @weakify(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您确定要请求“%@”开启摄像头吗？", userModel.name] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        }];
        UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            @strongify(self);
            /// 请求打开成员摄像头
            [self.viewModel adminRequestUserOpenCamera:userId nickname:userModel.name];
        }];
        [alert addAction:cancelAction];
        [alert addAction:ensureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 移除成员确认弹窗
/// 移除成员确认弹窗
/// @param userId 成员标识
/// @param nickname 成员昵称
- (void)presentRoomKickoutAlert:(NSString *)userId nickname:(NSString *)nickname {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您确定要移出“%@”吗？", nickname] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 请求踢出成员
        [self.viewModel queryRoomKickoutWithUserId:userId];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 成员被选中事件
/// 成员被选中事件
/// @param memberModel 成员信息
- (void)didSelectRowAtMemberModel:(FWRoomMemberModel *)memberModel {
    
    /// 获取当前账户信息
    SEAUserModel *userModel = [[MeetingKit sharedInstance] getMySelf];
    
    if (memberModel.isMine) {
        /// 成员选中自己提示弹窗
        [self memberSelectMineAlert:memberModel.userId];
    } else {
        /// 当前用户不为普通成员
        if (userModel.extend.role != SEAUserRoleNormal) {
            /// 主持人选中成员提示弹窗
            [self adminSelectMemberAlert:memberModel.userId];
        }
    }
}

#pragma mark - 主持人选中成员提示弹窗
/// 主持人选中成员提示弹窗
/// @param userId 用户标识
- (void)adminSelectMemberAlert:(NSString *)userId {
    
    @weakify(self);
    
    /// 获取用户数据
    SEAUserModel *userModel = [[MeetingKit sharedInstance] findMemberWithUserId:userId];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:userModel.name message:nil preferredStyle:isPhone ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    
    UIAlertAction *renameAction = [UIAlertAction actionWithTitle:@"改名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 更新成员参会名称提示弹窗
        [self changeMemberNickname:userModel isMine:NO];
    }];
    [alert addAction:renameAction];
    
    /// 获取当前麦克风状态
    BOOL microphoneState = (userModel.extend.micState == SEADeviceStateOpen);
    UIAlertAction *microphoneAction = [UIAlertAction actionWithTitle:microphoneState ? @"关闭麦克风" : @"开启麦克风" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 根据当前状态发起请求
        if (microphoneState) {
            /// 关闭远端用户麦克风
            [self.viewModel adminCloseUserMic:userId nickname:userModel.name];
        } else {
            /// 请求打开成员麦克风
            [self.viewModel adminRequestUserOpenMic:userId nickname:userModel.name];
        }
    }];
    [alert addAction:microphoneAction];
    
    /// 获取当前摄像头状态
    BOOL cameraState = (userModel.extend.cameraState == SEADeviceStateOpen);
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:cameraState ? @"关闭摄像头" : @"开启摄像头" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 根据当前状态发起请求
        if (cameraState) {
            /// 关闭远端用户摄像头
            [self.viewModel adminCloseUserCamera:userId nickname:userModel.name];
        } else {
            /// 请求打开成员摄像头
            [self.viewModel adminRequestUserOpenCamera:userId nickname:userModel.name];
        }
    }];
    [alert addAction:cameraAction];
    
    /// 获取聊天禁用状态
    BOOL chatDisabled = userModel.extend.chatDisabled;
    UIAlertAction *chatAction = [UIAlertAction actionWithTitle:chatDisabled ? @"解除聊天禁用" : @"设置聊天禁用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 变更用户聊天状态
        [self.viewModel adminUpdateUserChatDisabled:userId chatDisabled:!chatDisabled nickname:userModel.name];
    }];
    [alert addAction:chatAction];
    
    /// 该成员正在共享
    if (userModel.extend.shareType != SEAShareTypeNormal) {
        UIAlertAction *stopShareAction = [UIAlertAction actionWithTitle:@"停止他的共享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            @strongify(self);
            /// 关闭共享
            [self.viewModel adminStopRoomShare:userModel.name];
        }];
        [alert addAction:stopShareAction];
    }
    
    /// 该成员不是主持人
    if (userModel.extend.role != SEAUserRoleHost) {
        /// 该成员当前为联席主持人
        if (userModel.extend.role == SEAUserRoleUnionHost) {
            UIAlertAction *removeUnionHostAction = [UIAlertAction actionWithTitle:@"回收联席主持人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                @strongify(self);
                /// 变更用户角色
                [self.viewModel adminUpdateUserRole:userId userRole:SEAUserRoleNormal nickname:userModel.name];
            }];
            [alert addAction:removeUnionHostAction];
        }
        /// 该成员当前为普通成员
        if (userModel.extend.role == SEAUserRoleNormal) {
            UIAlertAction *unionHostAction = [UIAlertAction actionWithTitle:@"设置联席主持人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                @strongify(self);
                /// 变更用户角色
                [self.viewModel adminUpdateUserRole:userId userRole:SEAUserRoleUnionHost nickname:userModel.name];
            }];
            [alert addAction:unionHostAction];
        }
        
        UIAlertAction *moveHostAction = [UIAlertAction actionWithTitle:@"设置主持人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            @strongify(self);
            /// 转移主持人
            [self.viewModel adminMoveHost:userId nickname:userModel.name];
        }];
        [alert addAction:moveHostAction];
    }
    
    UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"移出会议" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 移除成员确认弹窗
        [self presentRoomKickoutAlert:userId nickname:userModel.name];
    }];
    [alert addAction:removeAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 成员选中自己提示弹窗
/// 成员选中自己提示弹窗
/// @param userId 用户标识
- (void)memberSelectMineAlert:(NSString *)userId {
    
    @weakify(self);
    
    /// 获取当前账户信息
    SEAUserModel *userModel = [[MeetingKit sharedInstance] getMySelf];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:userModel.name message:nil preferredStyle:isPhone ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    
    UIAlertAction *renameAction = [UIAlertAction actionWithTitle:@"改名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 更新成员参会名称提示弹窗
        [self changeMemberNickname:userModel isMine:YES];
    }];
    [alert addAction:renameAction];
    
    /// 获取当前麦克风状态
    BOOL microphoneState = (userModel.extend.micState == SEADeviceStateOpen);
    UIAlertAction *microphoneAction = [UIAlertAction actionWithTitle:microphoneState ? @"关闭麦克风" : @"开启麦克风" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        /// 根据当前状态发起请求
        if (microphoneState) {
            /// 发送请求关闭麦克风通知
            [[NSNotificationCenter defaultCenter] postNotificationName:FWMeetingQueryCloseMicrophoneNotification object:nil];
        } else {
            /// 发送请求开启麦克风通知
            [[NSNotificationCenter defaultCenter] postNotificationName:FWMeetingQueryOpenMicrophoneNotification object:nil];
        }
    }];
    [alert addAction:microphoneAction];
    
    /// 获取当前摄像头状态
    BOOL cameraState = (userModel.extend.cameraState == SEADeviceStateOpen);
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:cameraState ? @"关闭摄像头" : @"开启摄像头" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        /// 根据当前状态发起请求
        if (cameraState) {
            /// 发送请求关闭摄像头通知
            [[NSNotificationCenter defaultCenter] postNotificationName:FWMeetingQueryCloseCameraNotification object:nil];
        } else {
            /// 发送请求开启摄像头通知
            [[NSNotificationCenter defaultCenter] postNotificationName:FWMeetingQueryOpenCameraNotification object:nil];
        }
    }];
    [alert addAction:cameraAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 更新成员参会名称提示弹窗
/// 更新成员参会名称提示弹窗
/// - Parameter userModel: 用户数据
/// - Parameter isMine: 是否是自己
- (void)changeMemberNickname:(SEAUserModel *)userModel isMine:(BOOL)isMine {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"改名" preferredStyle:UIAlertControllerStyleAlert];
    
    /// 在对话框中添加输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        /// 设置输入框内容
        textField.text = userModel.name;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 获取新昵称
        NSString *nickname = [[alert textFields] firstObject].text;
        /// 根据选中用户是否为自己发起请求
        if (isMine) {
            /// 更新自己的昵称
            [self.viewModel queryUpdateMineName:nickname];
        } else {
            /// 更新成员昵称
            [self.viewModel queryUpdateName:userModel.userId nickname:nickname];
        }
    }];
    [alert addAction:ensureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
