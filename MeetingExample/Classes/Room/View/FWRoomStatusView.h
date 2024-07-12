//
//  FWRoomStatusView.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/1.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FWRoomMemberModel;

@interface FWRoomStatusView : UIView

/// 当前成员数据
@property (strong, nonatomic, readonly) FWRoomMemberModel *memberModel;

#pragma mark - 设置/更新成员数据
/// 设置/更新成员数据
/// - Parameter memberModel: 成员数据
- (void)setupMemberInfoWithMemberModel:(FWRoomMemberModel *)memberModel;

#pragma mark - 用户摄像头状态变化
/// 用户摄像头状态变化
/// @param cameraState 视频状态
- (void)userCameraStateChanged:(SEADeviceState)cameraState;

#pragma mark - 用户麦克风状态变化
/// 用户麦克风状态变化
/// @param micState 音频状态
- (void)userMicStateChanged:(SEADeviceState)micState;

@end

NS_ASSUME_NONNULL_END
