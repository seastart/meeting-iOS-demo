//
//  CALayer+Extension.m
//  MeetingExample
//
//  Created by SailorGa on 2023/2/28.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "CALayer+Extension.h"

@implementation CALayer(Extension)

- (void)setBorderUIColor:(UIColor *)color {
    
    self.borderColor = color.CGColor;
}

- (UIColor *)borderUIColor {
    
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
