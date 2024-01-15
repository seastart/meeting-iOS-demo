//
//  FWBaseTabBarViewController.h
//  MeetingExample
//
//  Created by SailorGa on 2024/1/15.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWBaseTabBarViewController : UITabBarController

/// 初始化首页根控制器
- (instancetype)initTabBarViewController;

/// 初始化首页根控制器
/// @param titles 标题列表
/// @param vcNames 控制器名称列表
/// @param images 常规模式icon列表
/// @param selectedImages 选中模式icon列表
- (instancetype)initWithTitles:(NSArray *)titles vcNames:(NSArray *)vcNames images:(NSArray *)images selectedImages:(NSArray *)selectedImages;

@end

NS_ASSUME_NONNULL_END
