//
//  FWRoomWhiteboardView.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/1.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FWRoomWhiteboardView;

@protocol FWRoomWhiteboardViewDelegate <NSObject>

#pragma mark 画板加载开始事件回调
/// 画板加载开始事件回调
/// - Parameter whiteboardView: 电子画板视图
- (void)whiteboardLoadingBegin:(FWRoomWhiteboardView *)whiteboardView;

#pragma mark 画板加载完成事件回调
/// 画板加载完成事件回调
/// - Parameter whiteboardView: 电子画板视图
- (void)whiteboardLoadingFinish:(FWRoomWhiteboardView *)whiteboardView;

#pragma mark 离开事件回调
/// 离开事件回调
/// - Parameters:
///   - whiteboardView: 电子画板视图
///   - source: 事件源对象
- (void)whiteboardView:(FWRoomWhiteboardView *)whiteboardView didSelectLeaveButton:(UIButton *)source;

@end

@interface FWRoomWhiteboardView : UIView

/// 回调代理
@property (nonatomic, weak) IBOutlet id <FWRoomWhiteboardViewDelegate> delegate;

#pragma mark - 获取画板显示状态
/// 获取画板显示状态
- (BOOL)whiteboardHidden;

#pragma mark - 显示视图
/// 显示视图
/// - Parameters:
///   - host: 画板地址
///   - userId: 用户标识
///   - roomNo: 房间号码
///   - readwrite: 是否拥有读写权限
- (void)showView:(NSString *)host userId:(NSString *)userId roomNo:(NSString *)roomNo readwrite:(BOOL)readwrite;

#pragma mark - 隐藏视图
/// 隐藏视图
- (void)hiddenView;

@end

NS_ASSUME_NONNULL_END
