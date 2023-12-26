//
//  UIView+EmptyView.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/8.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView(EmptyView)

- (void)setupEmptyViewWithImage:(UIImage *)image titleStr:(nullable NSString *)titleStr detailStr:(nullable NSString *)detailStr;

@end

NS_ASSUME_NONNULL_END
