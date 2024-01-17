//
//  FWAccountPrivacyTableViewCell.h
//  MeetingExample
//
//  Created by SailorGa on 2024/1/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWAccountPrivacyTableViewCell : UITableViewCell

/// 创建Table View Cell
/// - Parameter tableView: Table View
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/// 设置项目内容
/// - Parameters:
///   - titleText: 标题
- (void)setupWithTitleText:(NSString *)titleText;

@end

NS_ASSUME_NONNULL_END
