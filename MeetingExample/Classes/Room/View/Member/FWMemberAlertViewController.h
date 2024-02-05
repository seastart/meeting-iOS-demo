//
//  FWMemberAlertViewController.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 取消按钮事件回调
typedef void (^FWMemberAlertCancelBlock)(void);
/// 确定按钮事件回调
typedef void (^FWMemberAlertEnsureBlock)(BOOL selected);

@interface FWMemberAlertViewController : FWBaseViewController

#pragma mark - 创建弹窗实例
/// 创建弹窗实例
/// @param title 标题
/// @param message 描述
/// @param cancelTitle 取消按钮文本
/// @param ensureTitle 确定按钮文本
/// @param cancelBlock 取消按钮事件回调
/// @param ensureBlock 确定按钮事件回调
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelTitle:(nullable NSString *)cancelTitle ensureTitle:(nullable NSString *)ensureTitle cancelBlock:(nullable FWMemberAlertCancelBlock)cancelBlock ensureBlock:(nullable FWMemberAlertEnsureBlock)ensureBlock;

@end

NS_ASSUME_NONNULL_END
