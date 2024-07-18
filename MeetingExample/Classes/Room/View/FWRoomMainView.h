//
//  FWRoomMainView.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/1.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <ReplayKit/ReplayKit.h>
#import "FWMeetingEnterModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FWRoomMainView;
@class FWRoomMemberModel;

@protocol FWRoomMainViewDelegate <NSObject>

#pragma mark 聊天事件回调
/// 聊天事件回调
/// @param mainView 主窗口视图
- (void)onChatEventMainView:(FWRoomMainView *)mainView;

#pragma mark 成员管理事件回调
/// 成员管理事件回调
/// @param mainView 主窗口视图
- (void)onMemberEventMainView:(FWRoomMainView *)mainView;

#pragma mark 举报事件回调
/// 举报事件回调
/// @param mainView 主窗口视图
- (void)onReportEventMainView:(FWRoomMainView *)mainView;

#pragma mark 开启共享事件回调
/// 开启共享事件回调
/// @param mainView 主窗口视图
- (void)onStartScreenMainView:(FWRoomMainView *)mainView;

#pragma mark 停止共享事件回调
/// 停止共享事件回调
/// @param mainView 主窗口视图
/// @param sharingType 共享类型
- (void)onStopScreenMainView:(FWRoomMainView *)mainView sharingType:(SEAShareType)sharingType;

#pragma mark 成员选择回调
/// 成员选择回调
/// @param mainView 主窗口视图
/// @param memberModel 成员数据
- (void)mainView:(FWRoomMainView *)mainView didSelectItemAtMemberModel:(FWRoomMemberModel *)memberModel;

#pragma mark 电子画板退出回调
/// 电子画板退出回调
/// @param mainView 主窗口视图
- (void)onLeaveWhiteboardMainView:(FWRoomMainView *)mainView;

#pragma mark 挂断事件回调
/// 挂断事件回调
/// @param mainView 主窗口视图
- (void)onHangupEventMainView:(FWRoomMainView *)mainView;

@end

@interface FWRoomMainView : UIView

/// 回调代理
@property (nonatomic, weak) IBOutlet id <FWRoomMainViewDelegate> delegate;
/// 屏幕共享状态
@property (nonatomic, assign, readonly) BOOL screenShareStatus;

#pragma mark - 进入房间
/// 进入房间
/// - Parameter userId: 用户标识
/// - Parameter enterModel: 加入房间信息
- (void)enterRoom:(NSString *)userId enterModel:(FWMeetingEnterModel *)enterModel;

#pragma mark - 成员加入房间
/// 成员加入房间
/// - Parameter userId: 成员标识
- (void)memberUserEnter:(NSString *)userId;

#pragma mark - 成员离开房间
/// 成员离开房间
/// - Parameter userId: 成员标识
- (void)memberUserExit:(NSString *)userId;

#pragma mark - 变更成员昵称
/// 变更成员昵称
/// - Parameters:
///   - userId: 成员标识
///   - nickname: 用户昵称
- (void)userNameChanged:(NSString *)userId nickname:(NSString *)nickname;

#pragma mark - 变更成员角色
/// 变更成员角色
/// - Parameters:
///   - userId: 成员标识
///   - userRole: 用户角色
- (void)userRoleChanged:(NSString *)userId userRole:(SEAUserRole)userRole;

#pragma mark - 用户摄像头状态变化
/// 用户摄像头状态变化
/// @param userId 成员标识
/// @param cameraState 视频状态
- (void)userCameraStateChanged:(NSString *)userId cameraState:(SEADeviceState)cameraState;

#pragma mark - 用户麦克风状态变化
/// 用户麦克风状态变化
/// @param userId 成员标识
/// @param micState 音频状态
- (void)userMicStateChanged:(NSString *)userId micState:(SEADeviceState)micState;

#pragma mark - 用户开始共享
/// 用户开始共享
/// @param userId 成员标识
/// @param shareType 共享类型
- (void)userRoomShareStart:(NSString *)userId shareType:(SEAShareType)shareType;

#pragma mark - 用户结束共享
/// 用户结束共享
/// @param userId 成员标识
/// @param shareType 共享类型
- (void)userRoomStopStart:(NSString *)userId shareType:(SEAShareType)shareType;

#pragma mark - 唤起屏幕录制组件视图
/// 唤起屏幕录制组件视图
- (void)wakeupBroadcastPickerView;

#pragma mark - 请求开始共享白板
/// 请求开始共享白板
- (void)requestStartDrawing;

#pragma mark - 请求开始共享屏幕
/// 请求开始共享屏幕
- (void)requestStartScreen;

#pragma mark - 请求关闭房间共享
/// 请求关闭房间共享
/// - Parameter sharingType: 共享类型
- (void)requestStopSharing:(SEAShareType)sharingType;

#pragma mark - 请求关闭视频
/// 请求关闭视频
/// - Parameter source: 事件源对象
- (void)requestCloseVideo:(nullable UIButton *)source;

#pragma mark - 请求开启视频
/// 请求开启视频
/// - Parameter source: 事件源对象
- (void)requestOpenVideo:(nullable UIButton *)source;

#pragma mark - 请求关闭音频
/// 请求关闭音频
/// - Parameter source: 事件源对象
- (void)requestCloseAudio:(nullable UIButton *)source;

#pragma mark - 请求开启音频
/// 请求开启音频
/// - Parameter source: 事件源对象
- (void)requestOpenAudio:(nullable UIButton *)source;

@end

NS_ASSUME_NONNULL_END
