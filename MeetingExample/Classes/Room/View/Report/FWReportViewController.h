//
//  FWReportViewController.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/4.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWReportViewController : FWBaseViewController

#pragma mark - 创建实例
/// 创建实例
/// @param titleText 标题
+ (instancetype)creatReportViewWithTitle:(nullable NSString *)titleText;

@end

NS_ASSUME_NONNULL_END
