//
//  FWRoomMemberWindowView.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/19.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FWRoomMemberWindowView;
@class FWRoomMemberModel;

@protocol FWRoomMemberWindowViewDelegate <NSObject>

#pragma mark 成员选择回调
/// 成员选择回调
/// @param windowView 成员视图对象
/// @param memberModel 成员数据
- (void)windowView:(FWRoomMemberWindowView *)windowView didSelectItemAtMemberModel:(FWRoomMemberModel *)memberModel;

@end

@interface FWRoomMemberWindowView : UIView

/// 回调代理
@property (nonatomic, weak) id <FWRoomMemberWindowViewDelegate> delegate;
/// 成员数据
@property (nonatomic, strong, nullable) FWRoomMemberModel *memberModel;
/// 成员标识
@property (nonatomic, strong, nullable) NSString *userId;

/// 获取播放窗口视图
- (UIView *)getPlayerWindow;

/// 用户摄像头状态变化
/// @param cameraState 视频状态
- (void)userCameraStateChanged:(SEADeviceState)cameraState;

/// 用户麦克风状态变化
/// @param micState 音频状态
- (void)userMicStateChanged:(SEADeviceState)micState;

/// 用户共享屏幕状态变化
/// @param enabled 变更状态，YES-开启 NO-关闭
- (void)userShareScreenChanged:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
