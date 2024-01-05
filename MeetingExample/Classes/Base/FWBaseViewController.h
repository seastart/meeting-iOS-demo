//
//  FWBaseViewController.h
//  MeetingExample
//
//  Created by SailorGa on 2021/10/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <SafariServices/SafariServices.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWBaseViewController : UIViewController

/// 标记当前顶部状态栏是否隐藏(YES-隐藏 NO-显示)
@property (assign, nonatomic) BOOL statusHiden;
/// 标记当前顶部状态栏样式
@property (assign, nonatomic) NSInteger barStyle;

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) id info;
@property (nonatomic, copy) void (^block)(id info);
#pragma mark child
@property (nonatomic, assign) CGRect childRect;

#pragma mark - 横竖屏切换
- (void)orientationToPortrait:(UIInterfaceOrientation)orientation;

#pragma mark - 设置顶部状态栏是否隐藏
- (void)statusBarAppearanceUpdateWithHiden:(BOOL)statusHiden barStyle:(UIStatusBarStyle)barStyle;

#pragma mark jump
- (void)present:(NSString *)vcName isFullScreen:(BOOL)isFullScreen;
- (void)push:(NSString *)vcName;

- (void)present:(NSString *)vcName isFullScreen:(BOOL)isFullScreen block:(nullable void(^)(id info))block;
- (void)push:(NSString *)vcName block:(nullable void(^)(id info))block;

- (void)present:(NSString *)vcName info:(nullable id)info isFullScreen:(BOOL)isFullScreen block:(nullable void(^)(id info))block;
- (void)push:(NSString *)vcName info:(nullable id)info block:(nullable void(^)(id info))block;

- (void)present:(NSString *)vcName info:(nullable id)info tag:(NSInteger)tag isFullScreen:(BOOL)isFullScreen block:(nullable void (^)(id info))block;
- (void)push:(NSString *)vcName info:(nullable id)info tag:(NSInteger)tag block:(nullable void (^)(id info))block;

- (void)present:(NSString *)vcName info:(nullable id)info tag:(NSInteger)tag title:(NSString *)titleStr isFullScreen:(BOOL)isFullScreen block:(nullable void (^)(id))block;
- (void)push:(NSString *)vcName info:(nullable id)info tag:(NSInteger)tag title:(NSString *)titleStr block:(nullable void (^)(id))block;

- (void)present:(NSString *)vcName tag:(NSInteger)tag isFullScreen:(BOOL)isFullScreen;
- (void)push:(NSString *)vcName tag:(NSInteger)tag;

/// pop
/// @param num 等于1时为pop到上一个页面 依此类推 (>0)
- (void)pop:(NSUInteger)num;

/// 返回上一级(dismissViewControllerAnimated)
- (void)dismiss;

- (void)addChildVC:(FWBaseViewController *)vc rect:(CGRect)rect;

#pragma mark - 获取顶层控制器
/// 获取顶层控制器
- (UIViewController *)topViewController;

#pragma mark - 跳转用户协议
/// 跳转用户协议
- (void)presentUserAgreement;

#pragma mark - 跳转隐私协议
/// 跳转隐私协议
- (void)presentPrivacyAgreement;

/// 退出房间
- (void)dismissRoom;

@end

NS_ASSUME_NONNULL_END
