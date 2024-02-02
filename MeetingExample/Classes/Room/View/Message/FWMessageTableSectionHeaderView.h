//
//  FWMessageTableSectionHeaderView.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/2.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWMessageTableSectionHeaderView : UITableViewHeaderFooterView

#pragma mark - 设置显示标题
/// 设置显示标题
/// - Parameter titleText: 标题
- (void)setupTitleText:(NSString *)titleText;

@end

NS_ASSUME_NONNULL_END
