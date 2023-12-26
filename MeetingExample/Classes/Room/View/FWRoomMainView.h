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

#pragma mark 变更信息事件回调
/// 变更信息事件回调
/// @param mainView 主窗口视图
- (void)onChangeEventMainView:(FWRoomMainView *)mainView;

#pragma mark 挂断事件回调
/// 挂断事件回调
/// @param mainView 主窗口视图
- (void)onHangupEventMainView:(FWRoomMainView *)mainView;

#pragma mark 停止共享事件回调
/// 停止共享事件回调
/// @param mainView 主窗口视图
- (void)onStopScreenMainView:(FWRoomMainView *)mainView;

#pragma mark 成员选择回调
/// 成员选择回调
/// @param mainView 主窗口视图
/// @param memberModel 成员信息
/// @param indexPath 选中索引
- (void)mainView:(FWRoomMainView *)mainView didSelectItemMemberModel:(FWRoomMemberModel *)memberModel didIndexPath:(NSIndexPath *)indexPath;

@end

@interface FWRoomMainView : UIView

/// 回调代理
@property (nonatomic, weak) IBOutlet id <FWRoomMainViewDelegate> delegate;
/// 屏幕共享状态
@property (nonatomic, assign, readonly) BOOL screenShareStatus;

#pragma mark - 订阅成员视频流
/// 订阅成员视频流
/// @param memberModel 成员信息
/// @param trackId 轨道标识
/// @param subscribe 订阅状态
//- (void)subscribeWithMemberModel:(FWRoomMemberModel *)memberModel trackId:(RTCTrackIdentifierFlags)trackId subscribe:(BOOL)subscribe;

@end

NS_ASSUME_NONNULL_END
