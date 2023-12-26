//
//  UITextView+AutoHeight.m
//  MeetingExample
//
//  Created by SailorGa on 2021/4/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "UITextView+AutoHeight.h"
#import <objc/runtime.h>

@interface UITextView ()

@property (nonatomic, weak) id auto_observer;

@end

static CGFloat const defaultMinHeight = 34;

@implementation UITextView(AutoHeight)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self, NSSelectorFromString(@"dealloc")), class_getInstanceMethod(self, @selector(auto_dealloc)));
        method_exchangeImplementations(class_getInstanceMethod(self, NSSelectorFromString(@"setText:")), class_getInstanceMethod(self, @selector(auto_setText:)));
    });
}

- (void)auto_dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.auto_observer];
    [self auto_dealloc];
}

- (void)auto_setText:(NSString *)text {
    
    [self auto_setText:text];
    if (text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    } else {
        self.placeHolderLabel.hidden = NO;
    }
}

#pragma mark ---setters getters
- (void)setAuto_observer:(id)auto_observer {
    
    objc_setAssociatedObject(self, @selector(auto_observer), auto_observer, OBJC_ASSOCIATION_ASSIGN);
}

- (id)auto_observer {
    
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj;
}

- (void)setIsAutoHeightEnable:(BOOL)isAutoHeightEnable {
    
    objc_setAssociatedObject(self, @selector(isAutoHeightEnable), @(isAutoHeightEnable), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isAutoHeightEnable {
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setMaxHeight:(CGFloat)maxHeight {
    
    objc_setAssociatedObject(self, @selector(maxHeight), @(maxHeight), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)maxHeight {
    
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setMinHeight:(CGFloat)minHeight {
    
    objc_setAssociatedObject(self, @selector(minHeight), @(minHeight), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)minHeight {
    
    CGFloat minHeight = [objc_getAssociatedObject(self, _cmd) floatValue];
    if (minHeight == 0) {
        minHeight = defaultMinHeight;
    }
    return minHeight;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    
    if (!placeHolder) {
        return;
    }
    if (!self.auto_observer) {
        
        __weak typeof(self) weakSelf = self;
       id observer = [[NSNotificationCenter defaultCenter]addObserverForName:UITextViewTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (note.object == strongSelf) {
                if (strongSelf.text.length == 0) {
                    strongSelf.placeHolderLabel.hidden = NO;
                }else{
                    strongSelf.placeHolderLabel.hidden = YES;
                }
            }
        }];
        self.auto_observer = observer;
    }
    objc_setAssociatedObject(self, @selector(placeHolder), placeHolder, OBJC_ASSOCIATION_COPY);
    self.placeHolderLabel.text = placeHolder;
}

- (NSString *)placeHolder {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    
    objc_setAssociatedObject(self, @selector(placeHolderColor), placeHolderColor, OBJC_ASSOCIATION_RETAIN);
    self.placeHolderLabel.textColor = placeHolderColor;
}

- (UIColor *)placeHolderColor {
    
    UIColor *placeholderColor = objc_getAssociatedObject(self, _cmd);
    if (!placeholderColor) {
        placeholderColor = [UIColor lightGrayColor];
    }
    return placeholderColor;
}

- (void)setPlaceHolderLabel:(UILabel *)placeHolderLabel {
    
    objc_setAssociatedObject(self, @selector(placeHolderLabel), placeHolderLabel, OBJC_ASSOCIATION_RETAIN);
}

- (UITextView *)placeHolderLabel {
    
    UITextView *placeHolderLabel = objc_getAssociatedObject(self, _cmd);
    if (!placeHolderLabel) {
        placeHolderLabel = [[UITextView alloc]initWithFrame:self.bounds];
        placeHolderLabel.textContainerInset = self.textContainerInset;
        placeHolderLabel.font = self.font;
        placeHolderLabel.userInteractionEnabled = NO;
        placeHolderLabel.backgroundColor = [UIColor clearColor];
        placeHolderLabel.textColor = self.placeHolderColor;
        placeHolderLabel.scrollEnabled = NO;
        [self addSubview:placeHolderLabel];
        objc_setAssociatedObject(self, _cmd, placeHolderLabel, OBJC_ASSOCIATION_RETAIN);
    }
    return placeHolderLabel;
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    
    objc_setAssociatedObject(self, @selector(lineSpacing), @(lineSpacing), OBJC_ASSOCIATION_ASSIGN);
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    /// 字体的行间距
    paragraphStyle.lineSpacing = self.lineSpacing;
    NSMutableDictionary * attributes = self.typingAttributes.mutableCopy;
    [attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    self.typingAttributes = attributes;
    if (self.text.length > 0) {
        self.text = self.text;
    }
}

- (CGFloat)lineSpacing {
    
    CGFloat line =[objc_getAssociatedObject(self, _cmd) floatValue];
    return line;
}

- (NSString *)layout_key {
    
    NSString * layout_key = objc_getAssociatedObject(self, _cmd);
    if (!layout_key) {
        layout_key = layout_frame;
        NSArray * sup_layouts = self.superview.constraints;
        for (NSLayoutConstraint * constraint in sup_layouts) {
            if (constraint.firstItem == self || constraint.secondItem == self) {
                layout_key = auto_layout;
                break;
            } else continue;
        }
        objc_setAssociatedObject(self, _cmd, layout_key, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return layout_key;
}

- (void)setLayout_key:(NSString *)layout_key {
    
    objc_setAssociatedObject(self, @selector(layout_key), layout_key, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setHeightConstraint:(NSLayoutConstraint *)heightConstraint {
    
    objc_setAssociatedObject(self, @selector(heightConstraint), heightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)heightConstraint {
    
    NSLayoutConstraint * constraint = objc_getAssociatedObject(self, _cmd);
    if (!constraint) {
        NSArray * constraints = self.constraints;
        for (NSLayoutConstraint * item in constraints) {
            if (item.firstAttribute == NSLayoutAttributeHeight) {
                constraint = item;
                objc_setAssociatedObject(self, @selector(heightConstraint), constraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                break;
            }
        }
    }
    return constraint;
}

- (void)setTextViewHeightDidChangedHandle:(void (^)(CGFloat))textViewHeightDidChangedHandle {
    
    objc_setAssociatedObject(self, @selector(textViewHeightDidChangedHandle), textViewHeightDidChangedHandle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(CGFloat textViewHeight))textViewHeightDidChangedHandle {
    
    return objc_getAssociatedObject(self, _cmd);
}

@end
