//
//  UIView+Extension.h
//  MeetingExample
//
//  Created by SailorGa on 2023/2/28.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView(Extension)

@property CGFloat sa_width;
@property CGFloat sa_height;
@property CGFloat sa_x;
@property CGFloat sa_y;
@property CGFloat sa_right;
@property CGFloat sa_bottom;
@property CGFloat sa_centerX;
@property CGFloat sa_centerY;
@property CGSize  sa_size;
@property CGFloat sa_radius;

- (void)addBorderColor:(UIColor *)color;
- (UIImage *)makeImageWithView;
+ (instancetype)sa_viewFromXib;

@end

NS_ASSUME_NONNULL_END
