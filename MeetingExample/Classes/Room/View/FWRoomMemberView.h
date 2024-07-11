//
//  FWRoomMemberView.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/19.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWRoomMemberWindowView.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FWRoomMemberView;
@class FWRoomMemberModel;

@protocol FWRoomMemberViewDelegate <NSObject>

#pragma mark 成员选择回调
/// 成员选择回调
/// @param memberView 成员列表对象
/// @param userId 成员标识
/// @param memberModel 成员信息
- (void)memberView:(FWRoomMemberView *)memberView didSelectItemAtUserId:(NSString *)userId memberModel:(FWRoomMemberModel *)memberModel;

@end

@interface FWRoomMemberView : UIView

/// 回调代理
@property (nonatomic, weak) IBOutlet id <FWRoomMemberViewDelegate> delegate;
/// 自己的预览视图
@property (strong, nonatomic, readonly) FWRoomMemberWindowView *mineWindowView;

#pragma mark - 进入房间成功
/// 进入房间成功
/// - Parameter userId: 用户标识
- (void)enterRoom:(NSString *)userId;

#pragma mark - 成员更新信息
/// 成员更新信息
/// @param userId 成员标识
- (void)memberUpdateWithUserId:(NSString *)userId;

#pragma mark - 成员离开房间
/// 成员离开房间
/// @param userId 成员标识
- (void)memberExitWithUserId:(NSString *)userId;

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

#pragma mark - 订阅成员视频流
/// 订阅成员视频流
/// @param memberModel 成员信息
/// @param trackId 轨道标识
/// @param subscribe 订阅状态
- (void)subscribeWithMemberModel:(FWRoomMemberModel *)memberModel trackId:(RTCTrackIdentifierFlags)trackId subscribe:(BOOL)subscribe;

@end

NS_ASSUME_NONNULL_END
