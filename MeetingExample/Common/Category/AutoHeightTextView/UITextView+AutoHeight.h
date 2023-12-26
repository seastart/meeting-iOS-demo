//
//  UITextView+AutoHeight.h
//  MeetingExample
//
//  Created by SailorGa on 2021/4/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const layout_frame = @"layout_frame";
static NSString * const auto_layout = @"auto_layout";

IB_DESIGNABLE
@interface UITextView(AutoHeight)

/// 是否自适应高度
@property (nonatomic, assign) IBInspectable BOOL isAutoHeightEnable;

/// 最大高度
@property (nonatomic, assign) IBInspectable CGFloat maxHeight;

/// 最小高度
@property (nonatomic, assign) CGFloat minHeight;

/// 占位符
@property (nonatomic, copy) IBInspectable NSString *placeHolder;

/// 占位符颜色
@property (nonatomic, strong) UIColor *placeHolderColor;

/// 占位Label
@property (nonatomic, strong) UITextView *placeHolderLabel;

/// 行间距
@property (nonatomic, assign) IBInspectable CGFloat lineSpacing;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, copy) NSString *layout_key;
@property (nonatomic, copy) void(^textViewHeightDidChangedHandle)(CGFloat textViewHeight);

@end

NS_ASSUME_NONNULL_END
