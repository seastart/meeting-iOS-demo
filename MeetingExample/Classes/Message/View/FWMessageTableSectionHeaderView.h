//
//  FWMessageTableSectionHeaderView.h
//  MeetingExample
//
//  Created by SailorGa on 2023/2/28.
//  Copyright © 2023 SailorGa. All rights reserved.
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
