//
//  FWRoomCaptureView.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/6.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWRoomCaptureView : UIView

#pragma mark - 获取预览视图
/// 获取预览视图
- (UIView *)getPreview;

#pragma mark - 设置/更新成员信息
/// 设置/更新成员信息
- (void)setupMemberInfo;

#pragma mark - 开启摄像头预览
/// 开启摄像头预览
- (void)startLocalPreview;

#pragma mark - 停止摄像头预览
/// 停止摄像头预览
- (void)stopLocalPreview;

#pragma mark - 切换摄像头
/// 切换摄像头
- (void)switchCamera;

#pragma mark - 开启音频发送
/// 开启音频发送
- (void)startSendAudio;

#pragma mark - 停止音频发送
/// 停止音频发送
- (void)stopSendAudio;

@end

NS_ASSUME_NONNULL_END
