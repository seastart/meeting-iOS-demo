//
//  FWToastBridge.h
//  MeetingExample
//
//  Created by SailorGa on 2021/10/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWToastBridge : NSObject

/// 显示菊花
+ (void)showToastAction;

/// 隐藏菊花
+ (void)hiddenToastAction;

/// 显示消息
+ (void)showToastAction:(NSString *)message;

/// 显示消息Toast
/// @param message 显示的信息
/// @param locationStr 显示的位置：@"top" @"center" @"bottom" 传入字符串，默认center
/// @param showTime 显示的时间
+ (void)showToast:(NSString *)message location:(NSString *)locationStr showTime:(float)showTime;

/// 显示(带菊花的消息)
+ (void)showIndicatorToastAction:(NSString *)message;

/// 显示(带菊花的消息)
/// @param message 显示的信息
/// @param locationStr 显示的位置：@"top" @"center" @"bottom" 传入字符串，默认center
/// @param showTime 显示的时间
+ (void)showIndicatorToast:(NSString *)message location:(NSString *)locationStr showTime:(float)showTime;

/// 隐藏(带菊花的消息)
+ (void)hiddenIndicatorToastAction;

@end

NS_ASSUME_NONNULL_END
