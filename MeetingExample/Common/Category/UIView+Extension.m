//
//  UIView+Extension.m
//  MeetingExample
//
//  Created by SailorGa on 2023/2/28.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView(Extension)

- (void)setSa_width:(CGFloat)sa_width {
    
    CGRect rect = self.frame;
    rect.size.width = sa_width;
    self.frame = rect;
}

- (CGFloat)sa_width {
    
    return self.frame.size.width;
}

- (void)setSa_height:(CGFloat)sa_height {
    
    CGRect rect = self.frame;
    rect.size.height = sa_height;
    self.frame = rect;
}

- (CGFloat)sa_height {
    
    return self.frame.size.height;
}

- (void)setSa_x:(CGFloat)sa_x {
    
    CGRect rect = self.frame;
    rect.origin.x = sa_x;
    self.frame = rect;
}

- (CGFloat)sa_x {
    
    return self.frame.origin.x;
}

- (void)setSa_y:(CGFloat)sa_y {
    
    CGRect rect = self.frame;
    rect.origin.y = sa_y;
    self.frame = rect;
}

- (CGFloat)sa_y {
    
    return self.frame.origin.y;
}

- (void)setSa_right:(CGFloat)sa_right {
    
    CGRect rect = self.frame;
    rect.origin.x = sa_right - rect.size.width;
    self.frame = rect;
}

- (CGFloat)sa_right {
    
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setSa_bottom:(CGFloat)sa_bottom {
    
    CGRect rect = self.frame;
    rect.origin.y = sa_bottom - rect.size.height;
    self.frame = rect;
}

- (CGFloat)sa_bottom {
    
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setSa_centerX:(CGFloat)sa_centerX {
    
    CGPoint center = self.center;
    center.x = sa_centerX;
    self.center = center;
}

- (CGFloat)sa_centerX {
    
    return self.center.x;
}

- (void)setSa_centerY:(CGFloat)sa_centerY {
    
    CGPoint center = self.center;
    center.y = sa_centerY;
    self.center = center;
}

- (CGFloat)sa_centerY {
    
    return self.center.y;
}

- (void)setSa_size:(CGSize)sa_size {
    
    CGRect rect = self.frame;
    rect.size = sa_size;
    self.frame = rect;
}

- (CGSize)sa_size {
    
    return self.frame.size;
}

- (void)setSa_radius:(CGFloat)sa_radius {
    
    self.layer.cornerRadius = sa_radius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)sa_radius {
    
    return self.layer.cornerRadius;
}

- (void)addBorderColor:(UIColor *)color {
    
    [self.layer setBorderColor:color.CGColor];
    [self.layer setBorderWidth:0.5];
    [self.layer setCornerRadius:4];
}

- (UIImage *)makeImageWithView {
    
    /// 下面方法
    /// 第一个参数表示区域大小
    /// 第二个参数表示是否是非透明的，如果需要显示半透明效果，需要传NO，否则传YES。
    /// 第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale
    UIGraphicsBeginImageContextWithOptions(self.sa_size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)sa_viewFromXib {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end
