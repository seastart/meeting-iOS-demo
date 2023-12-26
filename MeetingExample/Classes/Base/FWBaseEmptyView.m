//
//  FWBaseEmptyView.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/8.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWBaseEmptyView.h"

@implementation FWBaseEmptyView

- (void)prepare {
    
    [super prepare];
    
    /// 子控件内边距
    self.subViewMargin = 0;
    /// 内容上边距
    self.contentViewY = self.bounds.size.height / 3 + 100;
    /// 标题文字大小样式
    self.titleLabFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0f];
    /// 标题文字颜色样式
    self.titleLabTextColor = RGBOF(0x999999);
    /// 自动展示占位图
    self.autoShowEmptyView = YES;
}

@end
