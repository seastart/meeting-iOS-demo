//
//  FWRoomViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/1.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWRoomViewController.h"
#import "FWRoomMemberModel.h"
#import "FWRoomExtendModel.h"
#import "FWRoomViewModel.h"
#import "FWRoomMainView.h"

@interface FWRoomViewController () <FWRoomMainViewDelegate>

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
    /// 更改状态栏颜色为白色
    [self statusBarAppearanceUpdateWithHiden:NO barStyle:UIStatusBarStyleLightContent];
}

#pragma mark - 页面渲染完成
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    /// 加入房间状态未标记
    if (!self.joinRoomStatus) {
        /// 数据完成设置后加入房间
        [self onJoinRoomWithRoomNo:self.viewModel.roomText];
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
    self.viewModel = [[FWRoomViewModel alloc] initWithRoomNo:self.info];
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
/// @param roomNo 房间号码
- (void)onJoinRoomWithRoomNo:(NSString *)roomNo {
    
    /// 标记加入房间状态
    self.joinRoomStatus = YES;
    
//    /// 创建扩展信息
//    FWUserExtendModel *extendModel = [[FWUserExtendModel alloc] init];
//    /// 设置默认视频状态
//    extendModel.videoState = YES;
//    /// 设置默认音频状态
//    extendModel.audioState = YES;
//    /// 创建账户对象
//    RTCEngineUserModel *userModel = [[RTCEngineUserModel alloc] init];
//    /// 设置账户扩展信息
//    userModel.props = extendModel;
//    
//    /// 加入房间
//    RTCEngineError errorCode = [[FWEngineBridge sharedManager] joinRoomWithRoomNo:roomNo userModel:userModel];
//    /// 加入房间成功
//    if (errorCode == RTCEngineErrorOK) {
//        /// 结束此次操作
//        return;
//    }
//    NSString *toastStr = [NSString stringWithFormat:@"加入房间失败 errorCode = %ld", errorCode];
//    [FWToastBridge showToastAction:toastStr];
//    SGLOG(@"%@", toastStr);
//    /// 加入房间失败，结束并退出当前页面
//    [self joinRoomFailAlert:errorCode];
}

#pragma mark - ----- FWRoomMainViewDelegate的代理方法 -----
#pragma mark 变更信息事件回调
/// 变更信息事件回调
/// @param mainView 主窗口视图
- (void)onChangeEventMainView:(FWRoomMainView *)mainView {
    
    /// 修改成员信息弹窗
    [self changeUserInfoAlert];
}

#pragma mark 聊天事件回调
/// 聊天事件回调
/// @param mainView 主窗口视图
- (void)onChatEventMainView:(FWRoomMainView *)mainView {
    
    /// 跳转消息页面
    [self push:@"FWMessageViewController" block:nil];
}

#pragma mark 挂断事件回调
/// 挂断事件回调
/// @param mainView 主窗口视图
- (void)onHangupEventMainView:(FWRoomMainView *)mainView {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要离开房间吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *leaveAction = [UIAlertAction actionWithTitle:@"离开房间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 离开房间页面
        [self pop:1];
    }];
    [alert addAction:cancelAction];
    [alert addAction:leaveAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 停止共享事件回调
/// 停止共享事件回调
/// @param mainView 主窗口视图
- (void)onStopScreenMainView:(FWRoomMainView *)mainView {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要停止共享吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        /// 关闭屏幕录制
//        [[FWEngineBridge sharedManager] stopScreenRecord];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 成员选择回调
/// 成员选择回调
/// @param mainView 主窗口视图
/// @param memberModel 成员信息
/// @param indexPath 选中索引
- (void)mainView:(FWRoomMainView *)mainView didSelectItemMemberModel:(FWRoomMemberModel *)memberModel didIndexPath:(NSIndexPath *)indexPath {
    
    /// 订阅成员轨道弹窗
    [self subscribeMemberAlert:memberModel];
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
//        textField.text = [[FWStoreDataBridge sharedManager] getUserModel].name;
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
        
//        /// 创建用户信息
//        RTCEngineUserModel *memberModel = [[RTCEngineUserModel alloc] init];
//        /// 设置新的昵称
//        memberModel.name = name;
//        /// 变更用户信息
//        RTCEngineError errorCode = [[FWEngineBridge sharedManager] changeWithUserModel:memberModel];
//        if (errorCode != RTCEngineErrorOK) {
//            NSString *toastStr = [NSString stringWithFormat:@"变更用户信息失败 errorCode = %ld", errorCode];
//            [FWToastBridge showToastAction:toastStr];
//            SGLOG(@"%@", toastStr);
//        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 订阅成员轨道弹窗
/// 订阅成员轨道弹窗
/// @param memberModel 成员信息
- (void)subscribeMemberAlert:(FWRoomMemberModel *)memberModel {
    
//    /// 获取成员详细信息
//    RTCEngineUserModel *userModel = [[FWEngineBridge sharedManager] findMemberWithUserId:memberModel.uid];
//    if (!userModel) {
//        [FWToastBridge showToastAction:@"该成员已离线"];
//        return;
//    }
//    
//    /// 创建对话框标题
//    NSString *title = [NSString stringWithFormat:@"%@ 所有发送流类型", [userModel.name nicknameSuitScanf]];
//    
//    @weakify(self);
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:isPhone ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
//    }];
//    [alert addAction:cancelAction];
//    
//    for (RTCEngineStreamModel *streamModel in userModel.streams) {
//        /// 显示视频类型的轨道列表
//        if (streamModel.mediaType == RTCMediaTypeVideo) {
//            NSString *title = @"未知流";
//            /// 添加轨道列表
//            switch (streamModel.type) {
//                case 0:
//                    title = @"大流";
//                    break;
//                case 1:
//                    title = @"小流";
//                    break;
//                case 2:
//                    title = @"共享流";
//                    break;
//                case 3:
//                    title = @"音频流";
//                    break;
//                default:
//                    title = @"未知流";
//                    break;
//            }
//            UIAlertAction *trackAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                @strongify(self);
//                /// 订阅成员视频流
//                [self.roomMainView subscribeWithMemberModel:memberModel trackId:streamModel.id subscribe:YES];
//            }];
//            [alert addAction:trackAction];
//        }
//    }
//    
//    UIAlertAction *emptyAction = [UIAlertAction actionWithTitle:@"空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//        @strongify(self);
//        /// 取消订阅成员视频流
//        [self.roomMainView subscribeWithMemberModel:memberModel trackId:memberModel.trackIdentifier subscribe:NO];
//    }];
//    [alert addAction:emptyAction];
//    
//    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 加入房间失败
//- (void)joinRoomFailAlert:(RTCEngineError)errorCode {
//    
//    @weakify(self);
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"加入房间失败(%ld)", errorCode] preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
//        @strongify(self);
//        /// 离开房间页面
//        [self pop:1];
//    }];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:nil];
//}

#pragma mark - 资源释放
- (void)dealloc {
    
    /// 退出房间
//    [[FWEngineBridge sharedManager] leaveRoom];
    /// 清空聊天数据
    [[FWMessageChatManager sharedManager] cleanChatsCache];
    /// 取消限制锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    /// 移除所有监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
