//
//  UIScrollView+AutoHeight.m
//  MeetingExample
//
//  Created by SailorGa on 2021/4/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "UIScrollView+AutoHeight.h"
#import "UITextView+AutoHeight.h"
#import <objc/runtime.h>

@implementation UIScrollView(AutoHeight)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(setContentSize:)), class_getInstanceMethod(self, @selector(auto_setContentSize:)));
    });
}

- (void)auto_setContentSize:(CGSize)contentSize {
    
    if ([self isKindOfClass:[UITextView class]]) {
        
        UITextView *auto_view = (UITextView *)self;
        if (auto_view.isAutoHeightEnable) {
            
            NSString *key = auto_view.layout_key;
            CGFloat height = contentSize.height;
            CGRect frame = self.frame;
            if (auto_view.maxHeight > 0 && height > auto_view.maxHeight) {
                height = auto_view.maxHeight;
            }
            if (height < auto_view.minHeight && auto_view.minHeight > 0) {
                height = auto_view.minHeight;
            }
            frame.size.height = height;
            if ([key isEqualToString:layout_frame]) {
                self.frame = frame;
            } else {
                if (auto_view.heightConstraint) {
                    if ([auto_view.heightConstraint isKindOfClass:NSClassFromString(@"NSContentSizeLayoutConstraint")]) {
                        self.scrollEnabled = NO;
                    } else {
                        /// 主动添加了高度约束
                        self.scrollEnabled = YES;
                        self.frame = frame;
                        auto_view.heightConstraint.constant = height;
                    }
                } else {
                    self.scrollEnabled = NO;
                }
            }
        }
    }
    [self auto_setContentSize:contentSize];
}

@end
