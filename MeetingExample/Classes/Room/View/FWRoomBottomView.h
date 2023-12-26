//
//  FWRoomBottomView.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/1.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FWRoomBottomView;

@protocol FWRoomBottomViewDelegate <NSObject>

#pragma mark 音频控制事件回调
/// 音频控制事件回调
/// - Parameters:
///   - bottomView: 工具栏视图
///   - source: 事件源对象
- (void)bottomView:(FWRoomBottomView *)bottomView didSelectAudioButton:(UIButton *)source;

#pragma mark 视频控制事件回调
/// 视频控制事件回调
/// - Parameters:
///   - bottomView: 工具栏视图
///   - source: 事件源对象
- (void)bottomView:(FWRoomBottomView *)bottomView didSelectVideoButton:(UIButton *)source;

#pragma mark 共享控制事件回调
/// 共享控制事件回调
/// - Parameters:
///   - bottomView: 工具栏视图
///   - source: 事件源对象
- (void)bottomView:(FWRoomBottomView *)bottomView didSelectSharingButton:(UIButton *)source;

#pragma mark 聊天控制事件回调
/// 聊天控制事件回调
/// - Parameters:
///   - bottomView: 工具栏视图
///   - source: 事件源对象
- (void)bottomView:(FWRoomBottomView *)bottomView didSelectChatButton:(UIButton *)source;

@end

@interface FWRoomBottomView : UIView

/// 回调代理
@property (nonatomic, weak) IBOutlet id <FWRoomBottomViewDelegate> delegate;

#pragma mark - 设置音频按钮选中状态
/// 设置音频按钮选中状态
/// @param selected 选中状态
- (void)setupAudioButtonSelected:(BOOL)selected;

#pragma mark - 设置视频按钮选中状态
/// 设置视频按钮选中状态
/// @param selected 选中状态
- (void)setupVideoButtonSelected:(BOOL)selected;

#pragma mark - 设置共享按钮选中状态
/// 设置共享按钮选中状态
/// @param selected 选中状态
- (void)setupShareButtonSelected:(BOOL)selected;

#pragma mark - 显示视图
/// 显示视图
- (void)showView;

#pragma mark - 隐藏视图
/// 隐藏视图
- (void)hiddenView;

@end

NS_ASSUME_NONNULL_END
