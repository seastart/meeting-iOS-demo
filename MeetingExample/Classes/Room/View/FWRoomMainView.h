//
//  FWRoomMainView.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/1.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <ReplayKit/ReplayKit.h>
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
- (void)onStopScreenMainView:(FWRoomMainView *)mainView sharingType:(FWMeetingSharingType)sharingType;

#pragma mark 成员选择回调
/// 成员选择回调
/// @param mainView 主窗口视图
/// @param memberModel 成员信息
/// @param userId 成员标识
- (void)mainView:(FWRoomMainView *)mainView didSelectItemMemberModel:(FWRoomMemberModel *)memberModel didUserId:(NSString *)userId;

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

#pragma mark - 设置默认音视频状态
/// 设置默认音视频状态
/// - Parameters:
///   - audioState: 音频状态
///   - videoState: 视频状态
- (void)setupDefaultAudioState:(BOOL)audioState videoState:(BOOL)videoState;

#pragma mark - 成员加入房间
/// 成员加入房间
/// - Parameter userId: 成员标识
- (void)memberUserEnter:(NSString *)userId;

#pragma mark - 成员离开房间
/// 成员离开房间
/// - Parameter userId: 成员标识
- (void)memberUserExit:(NSString *)userId;

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

#pragma mark - 请求开启房间共享
/// 请求开启房间共享
/// - Parameter sharingType: 共享类型
- (void)requestStartSharing:(FWMeetingSharingType)sharingType;

#pragma mark - 请求关闭房间共享
/// 请求关闭房间共享
/// - Parameter sharingType: 共享类型
- (void)requestStopSharing:(FWMeetingSharingType)sharingType;
@end

NS_ASSUME_NONNULL_END
