//
//  FWToastBridge.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWToastBridge.h"

@implementation FWToastBridge

#pragma mark - 懒加载相关控件
static UIView *toastView = nil;
+ (UIView *)currentToastView {
    
    @synchronized(self) {
        if (toastView == nil) {
            toastView = [[UIView alloc] init];
            toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
            toastView.layer.masksToBounds = YES;
            toastView.layer.cornerRadius = 5.0;
            toastView.alpha = 0;
            
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicatorView.tag = 10;
            indicatorView.hidesWhenStopped = YES;
            indicatorView.color = [UIColor whiteColor];
            [toastView addSubview:indicatorView];
        }
        return toastView;
    }
}

static UILabel *toastLabel = nil;
+ (UILabel *)currentToastLabel {
    
    @synchronized(self) {
        if (toastLabel == nil) {
            toastLabel = [[UILabel alloc] init];
            toastLabel.backgroundColor = [UIColor darkGrayColor];
            toastLabel.font = [UIFont systemFontOfSize:16];
            toastLabel.textColor = [UIColor whiteColor];
            toastLabel.numberOfLines = 0;
            toastLabel.textAlignment = NSTextAlignmentCenter;
            toastLabel.lineBreakMode = NSLineBreakByCharWrapping;
            toastLabel.layer.masksToBounds = YES;
            toastLabel.layer.cornerRadius = 5.0;
            toastLabel.alpha = 0;
        }
        return toastLabel;
    }
}

static UIView *toastViewLabel = nil;
+ (UIView *)currentToastViewLabel {
    
    @synchronized(self) {
        if (toastViewLabel == nil) {
            toastViewLabel = [[UIView alloc] init];
            toastViewLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
            toastViewLabel.layer.masksToBounds = YES;
            toastViewLabel.layer.cornerRadius = 5.0;
            toastViewLabel.alpha = 0;
            
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicatorView.tag = 10;
            indicatorView.hidesWhenStopped = YES;
            indicatorView.color = [UIColor whiteColor];
            [toastViewLabel addSubview:indicatorView];
            
            UILabel *label = [[UILabel alloc] init];
            label.tag = 11;
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 5.0;
            label.numberOfLines = 0;
            [toastViewLabel addSubview:label];
        }
        return toastViewLabel;
    }
}


#pragma mark - 显示菊花
/// 显示菊花
+ (void)showToastAction {
    
    if ([[NSThread currentThread] isMainThread]) {
        
        toastView = [self currentToastView];
        [toastView removeFromSuperview];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:toastView];
        
        CGFloat main_width = [[UIScreen mainScreen] bounds].size.width;
        CGFloat main_height = [[UIScreen mainScreen] bounds].size.height;
        
        UIActivityIndicatorView *indicatorView = [toastView viewWithTag:10];
        indicatorView.center = CGPointMake(70 / 2, 70 / 2);
        [indicatorView startAnimating];
        toastView.frame = CGRectMake((main_width - 70) / 2, (main_height - 70) / 2, 70, 70);
        toastView.alpha = 1;
    } else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showToastAction];
        });
        return;
    }
}

#pragma mark - 隐藏菊花
/// 隐藏菊花
+ (void)hiddenToastAction {
    
    if (toastView) {
        UIActivityIndicatorView *indicatorView = [toastView viewWithTag:10];
        [indicatorView stopAnimating];
        toastView.alpha = 0;
        [toastView removeFromSuperview];
    }
}

#pragma mark - 显示消息
/// 显示消息
+ (void)showToastAction:(NSString *)message {
    
    [self showToast:message location:@"center" showTime:2.5];
}

#pragma mark - 显示消息Toast
/// 显示消息Toast
/// @param message 显示的信息
/// @param locationStr 显示的位置：@"top" @"center" @"bottom" 传入字符串，默认center
/// @param showTime 显示的时间
+ (void)showToast:(NSString *)message location:(NSString *)locationStr showTime:(float)showTime {
    
    if (!message) {
        message = @"";
    }
    if ([[NSThread currentThread] isMainThread]) {
        
        toastLabel = [self currentToastLabel];
        [toastLabel removeFromSuperview];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:toastLabel];
        
        CGFloat main_width = [[UIScreen mainScreen] bounds].size.width;
        CGFloat main_height = [[UIScreen mainScreen] bounds].size.height;
        
        CGFloat width = [self stringText:message font:16 isHeightFixed:YES fixedValue:40];
        CGFloat height = 0;
        if (width > main_width - 20) {
            width = main_width - 20;
            height = [self stringText:message font:16 isHeightFixed:NO fixedValue:width];
        } else {
            height = 40;
        }
        
        CGRect labFrame;
        if (locationStr && [locationStr isEqualToString:@"top"]) {
            labFrame = CGRectMake((main_width - width) / 2, main_height * 0.15, width, height);
        } else if (locationStr && [locationStr isEqualToString:@"bottom"]) {
            labFrame = CGRectMake((main_width - width) / 2, main_height * 0.85, width, height);
        } else {
            labFrame = CGRectMake((main_width - width) / 2, main_height * 0.45, width, height);
        }
        toastLabel.frame = labFrame;
        toastLabel.text = message;
        toastLabel.alpha = 1;
        FWDispatchAfter((int64_t)(showTime * NSEC_PER_SEC), ^{
            toastLabel.alpha = 0;
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showToast:message location:locationStr showTime:showTime];
        });
        return;
    }
}

#pragma mark - 显示(带菊花的消息)
/// 显示(带菊花的消息)
+ (void)showIndicatorToastAction:(NSString *)message {
    
    [self showIndicatorToast:message location:@"center" showTime:2.0];
}

#pragma mark - 显示(带菊花的消息)
/// 显示(带菊花的消息)
/// @param message 显示的信息
/// @param locationStr 显示的位置：@"top" @"center" @"bottom" 传入字符串，默认center
/// @param showTime 显示的时间
+ (void)showIndicatorToast:(NSString *)message location:(NSString *)locationStr showTime:(float)showTime {
    
    if (!message) {
        message = @"";
    }
    if ([[NSThread currentThread] isMainThread]) {
        
        toastViewLabel = [self currentToastViewLabel];
        [toastViewLabel removeFromSuperview];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:toastViewLabel];
        
        CGFloat main_width = [[UIScreen mainScreen] bounds].size.width;
        CGFloat main_height = [[UIScreen mainScreen] bounds].size.height;
        
        CGFloat width = [self stringText:message font:16 isHeightFixed:YES fixedValue:40];
        CGFloat height = 0;
        if (width > main_width - 20) {
            width = main_width - 20;
            height = [self stringText:message font:16 isHeightFixed:NO fixedValue:width];
        } else {
            height = 40;
        }
        
        CGRect labFrame;
        if (locationStr && [locationStr isEqualToString:@"top"]) {
            labFrame = CGRectMake((main_width - width) / 2, main_height * 0.15, width, 60 + height);
        } else if (locationStr && [locationStr isEqualToString:@"bottom"]) {
            labFrame = CGRectMake((main_width - width) / 2, main_height * 0.85, width, 60 + height);
        } else {
            labFrame = CGRectMake((main_width - width) / 2, main_height * 0.45, width, 60 + height);
        }
        toastViewLabel.frame = labFrame;
        toastViewLabel.alpha = 1;
        
        UIActivityIndicatorView *indicatorView = [toastViewLabel viewWithTag:10];
        indicatorView.center = CGPointMake(width / 2, 70 / 2);
        [indicatorView startAnimating];
        
        UILabel *aLabel = [toastViewLabel viewWithTag:11];
        aLabel.frame = CGRectMake(0, 60, width, height);
        aLabel.text = message;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showIndicatorToast:message location:locationStr showTime:showTime];
        });
        return;
    }
}

#pragma mark - 隐藏(带菊花的消息)
/// 隐藏(带菊花的消息)
+ (void)hiddenIndicatorToastAction {
    
    if (toastViewLabel) {
        UIActivityIndicatorView *indicatorView = [toastViewLabel viewWithTag:10];
        [indicatorView stopAnimating];
        toastViewLabel.alpha = 0;
        [toastViewLabel removeFromSuperview];
    }
}

#pragma mark - 根据字符串长度获取对应的宽度或者高度
+ (CGFloat)stringText:(NSString *)text font:(CGFloat)font isHeightFixed:(BOOL)isHeightFixed fixedValue:(CGFloat)fixedValue {
    
    CGSize size;
    if (isHeightFixed) {
        size = CGSizeMake(MAXFLOAT, fixedValue);
    } else {
        size = CGSizeMake(fixedValue, MAXFLOAT);
    }
    
    CGSize resultSize = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        /// 返回计算出的size
        resultSize = [text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]} context:nil].size;
    }
    
    if (isHeightFixed) {
        /// 增加左右20间隔
        return resultSize.width + 20;
    } else {
        /// 增加上下20间隔
        return resultSize.height + 20;
    }
}

@end
