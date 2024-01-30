//
//  FWRoomTopView.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/1.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FWRoomTopView;

@protocol FWRoomTopViewDelegate <NSObject>

#pragma mark 扬声器事件回调
/// 扬声器事件回调
/// - Parameters:
///   - topView: 工具栏视图
///   - source: 事件源对象
- (void)topView:(FWRoomTopView *)topView didSelectSpeakerButton:(UIButton *)source;

#pragma mark 摄像头事件回调
/// 摄像头事件回调
/// - Parameters:
///   - topView: 工具栏视图
///   - source: 事件源对象
- (void)topView:(FWRoomTopView *)topView didSelectCameraButton:(UIButton *)source;

#pragma mark 举报事件回调
/// 举报事件回调
/// - Parameters:
///   - topView: 工具栏视图
///   - source: 事件源对象
- (void)topView:(FWRoomTopView *)topView didSelectReportButton:(UIButton *)source;

#pragma mark 挂断事件回调
/// 挂断事件回调
/// - Parameters:
///   - topView: 工具栏视图
///   - source: 事件源对象
- (void)topView:(FWRoomTopView *)topView didSelectHangupButton:(UIButton *)source;

@end

@interface FWRoomTopView : UIView

/// 回调代理
@property (nonatomic, weak) IBOutlet id <FWRoomTopViewDelegate> delegate;

#pragma mark - 设置数据
/// 设置数据
/// - Parameters:
///   - duration: 参会时长
///   - roomNoText: 房间号码
- (void)setupDataWithDuration:(NSInteger)duration roomNoText:(NSString *)roomNoText;

#pragma mark - 显示视图
/// 显示视图
- (void)showView;

#pragma mark - 隐藏视图
/// 隐藏视图
- (void)hiddenView;

@end

NS_ASSUME_NONNULL_END
