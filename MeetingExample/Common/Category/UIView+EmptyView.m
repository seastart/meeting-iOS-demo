//
//  UIView+EmptyView.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/8.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "UIView+EmptyView.h"
#import "FWBaseEmptyView.h"

@implementation UIView(EmptyView)

- (void)setupEmptyViewWithImage:(UIImage *)image titleStr:(nullable NSString *)titleStr detailStr:(nullable NSString *)detailStr {
    
    FWBaseEmptyView *emptyView = [FWBaseEmptyView emptyViewWithImage:image titleStr:titleStr detailStr:detailStr];
    self.ly_emptyView = emptyView;
}

@end
