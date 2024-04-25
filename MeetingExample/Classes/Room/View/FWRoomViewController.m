//
//  FWRoomViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/1.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWReportViewController.h"
#import "FWRoomViewController.h"
#import "FWRoomMemberModel.h"
#import "FWRoomExtendModel.h"
#import "FWRoomViewModel.h"
#import "FWRoomMainView.h"

@interface FWRoomViewController () <MeetingKitDelegate, FWRoomMainViewDelegate>

/// 房间主窗口视图
@property (weak, nonatomic) IBOutlet FWRoomMainView *roomMainView;

/// ViewModel
@property (strong, nonatomic) FWRoomViewModel *viewModel;
/// 房间加入状态
@property (assign, nonatomic) BOOL joinRoomStatus;

@end

@implementation FWRoomViewController

#pragma mark - 页面开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 限制锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    /// 隐藏顶部导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    /// 更改状态栏颜色为白色
    [self statusBarAppearanceUpdateWithHiden:NO barStyle:UIStatusBarStyleLightContent];
}

#pragma mark - 页面渲染完成
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    /// 加入房间状态未标记
    if (!self.joinRoomStatus) {
        /// 数据完成设置后加入房间
        [self handleJoinRoom];
    }
}

#pragma mark - 页面即将消失
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    /// 更改状态栏颜色为黑色
    [self statusBarAppearanceUpdateWithHiden:NO barStyle:UIStatusBarStyleDefault];
}

#pragma mark - 初始化操作
- (void)buildView {
    
    /// 设置ViewModel
    [self setupViewModel];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWRoomViewModel alloc] initWithMeetingEnterModel:self.info];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
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

#pragma mark - 加入房间
/// 加入房间
- (void)handleJoinRoom {
    
    @weakify(self);
    
    /// 设置事件回调
    [[MeetingKit sharedInstance] addDelegate:self];
    /// 标记加载状态
    self.viewModel.loading = YES;
    /// 构建加入会议参数
    SEAMeetingEnterParam *meetingEnterParam = [[SEAMeetingEnterParam alloc] init];
    meetingEnterParam.roomNo = self.viewModel.enterModel.roomNo;
    meetingEnterParam.nickname = self.viewModel.enterModel.nickname;
    /// 加入房间
    [[MeetingKit sharedInstance] enterRoom:meetingEnterParam onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.viewModel.loading = NO;
        /// 获取房间标识
        NSString *roomId = (NSString *)data;
        /// 保存加入会议信息
        [[FWStoreDataBridge sharedManager] enterRoom:self.viewModel.enterModel.roomNo roomId:roomId];
        /// 设置主窗口显示状态
        self.roomMainView.hidden = NO;
        /// 标记加入房间状态
        self.joinRoomStatus = YES;
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        /// 恢复加载状态
        self.viewModel.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"创建房间失败 code = %ld, message = %@", code, message];
        [FWToastBridge showToastAction:logStr];
        SGLOG(@"%@", logStr);
        /// 加入房间失败，结束并退出当前页面
        [self joinRoomFailAlert:code];
    }];
}


#pragma mark - ----- MeetingKitDelegate 代理方法 -----
#pragma mark ----- 错误事件回调 -----
#pragma mark 错误事件回调
/// 错误事件回调
/// - Parameters:
///   - errCode: 错误码
///   - errMsg: 错误信息
- (void)onError:(SEAError)errCode errMsg:(nullable NSString *)errMsg {
    
    /// 日志埋点
    SGLOG(@"发生了错误(%ld)，%@", errCode, errMsg);
}


#pragma mark ----- 房间事件回调 -----
#pragma mark 进入房间事件回调
/// 进入房间事件回调
/// - Parameters:
///   - roomId: 房间标识
///   - userId: 用户标识
- (void)onRoomEnter:(NSString *)roomId userId:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"加入房间成功，%@ %@", roomId, userId);
}





#pragma mark - ----- FWRoomMainViewDelegate的代理方法 -----
#pragma mark 聊天事件回调
/// 聊天事件回调
/// @param mainView 主窗口视图
- (void)onChatEventMainView:(FWRoomMainView *)mainView {
    
    /// 跳转消息页面
    [self push:@"FWMessageViewController" block:nil];
}

#pragma mark 成员管理事件回调
/// 成员管理事件回调
/// @param mainView 主窗口视图
- (void)onMemberEventMainView:(FWRoomMainView *)mainView {
    
    /// 跳转参会成员页面
    [self push:@"FWMemberViewController" block:nil];
}

#pragma mark 举报事件回调
/// 举报事件回调
/// @param mainView 主窗口视图
- (void)onReportEventMainView:(FWRoomMainView *)mainView {
    
    /// 创建举报视图
    FWReportViewController *reportVC = [FWReportViewController creatReportViewWithTitle:@"举报"];
    /// 跳转举报视图
    [self presentViewController:reportVC animated:NO completion:nil];
}

#pragma mark 开启共享事件回调
/// 开启共享事件回调
/// @param mainView 主窗口视图
- (void)onStartScreenMainView:(FWRoomMainView *)mainView {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:isPhone ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *screenAction = [UIAlertAction actionWithTitle:@"共享屏幕" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 请求开启房间共享(共享屏幕)
        [self.roomMainView requestStartSharing:FWMeetingSharingTypeScreen];
    }];
    UIAlertAction *whiteboardAction = [UIAlertAction actionWithTitle:@"共享白板" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 更改状态栏颜色为黑色
        [self statusBarAppearanceUpdateWithHiden:NO barStyle:UIStatusBarStyleDefault];
        /// 请求开启房间共享(共享白板)
        [self.roomMainView requestStartSharing:FWMeetingSharingTypeWhiteboard];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:screenAction];
    [alert addAction:whiteboardAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 停止共享事件回调
/// 停止共享事件回调
/// @param mainView 主窗口视图
/// @param sharingType 共享类型
- (void)onStopScreenMainView:(FWRoomMainView *)mainView sharingType:(FWMeetingSharingType)sharingType {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要停止共享吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 请求关闭房间共享
        [self.roomMainView requestStopSharing:sharingType];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 电子画板退出回调
/// 电子画板退出回调
/// @param mainView 主窗口视图
- (void)onLeaveWhiteboardMainView:(FWRoomMainView *)mainView {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要退出电子画板吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 更改状态栏颜色为白色
        [self statusBarAppearanceUpdateWithHiden:NO barStyle:UIStatusBarStyleLightContent];
        /// 关闭房间共享电子画板
        [self.roomMainView requestStopSharing:FWMeetingSharingTypeWhiteboard];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 挂断事件回调
/// 挂断事件回调
/// @param mainView 主窗口视图
- (void)onHangupEventMainView:(FWRoomMainView *)mainView {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定离开房间吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *leaveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 离开房间
        [self leaveRoom];
    }];
    [alert addAction:cancelAction];
    [alert addAction:leaveAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 成员选择回调
/// 成员选择回调
/// @param mainView 主窗口视图
/// @param memberModel 成员信息
/// @param userId 成员标识
- (void)mainView:(FWRoomMainView *)mainView didSelectItemMemberModel:(FWRoomMemberModel *)memberModel didUserId:(NSString *)userId {
    
    /// 订阅成员轨道弹窗
    /// [self subscribeMemberAlert:memberModel];
}


#pragma mark - 修改成员信息弹窗
/// 修改成员信息弹窗
- (void)changeUserInfoAlert {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改成员信息" message:nil preferredStyle:isPhone ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *nameAction = [UIAlertAction actionWithTitle:@"修改昵称" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 修改昵称二次弹窗
        [self changeNameAlert];
    }];
    [alert addAction:cancelAction];
    [alert addAction:nameAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 修改昵称二次弹窗
/// 修改昵称二次弹窗
- (void)changeNameAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    /// 在对话框中添加输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.borderStyle = UITextBorderStyleNone;
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"请输入新昵称";
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        /// 获取新昵称
        NSString *name = [[alert textFields] lastObject].text;
        /// 移除字符串两侧空格
        name = [FWToolBridge clearMarginsBlank:name];
        if (kStringIsEmpty(name)) {
            /// 提示操作信息
            [FWToastBridge showToastAction:@"用户昵称不能为空"];
            return;
        }
        
        if (![name isContentEffective]) {
            /// 提示操作信息
            [FWToastBridge showToastAction:@"用户昵称包含无效字符"];
            return;
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 离开房间
/// 离开房间
- (void)leaveRoom {
    
    @weakify(self);
    /// 离开房间
    [[MeetingKit sharedInstance] exitRoom:^(id  _Nullable data) {
        @strongify(self);
        /// 清空房间信息缓存
        [[FWStoreDataBridge sharedManager] exitRoom];
        /// 离开房间页面
        [self pop:1];
    }];
}

#pragma mark - 加入房间失败
- (void)joinRoomFailAlert:(SEAError)errorCode {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"加入房间失败(%ld)", errorCode] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 离开房间页面
        [self pop:1];
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 资源释放
- (void)dealloc {
    
    /// 取消限制锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    /// 移除所有监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
