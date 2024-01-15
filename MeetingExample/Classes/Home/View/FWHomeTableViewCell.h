//
//  FWHomeTableViewCell.h
//  MeetingExample
//
//  Created by SailorGa on 2024/1/15.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWHomeTableViewCell : UITableViewCell

/// 创建Table View Cell
/// - Parameter tableView: Table View
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/// 设置项目内容
/// - Parameters:
///   - imageName: 图片
///   - titleText: 标题
///   - describeText:  描述
- (void)setupWithImageName:(NSString *)imageName titleText:(NSString *)titleText describeText:(NSString *)describeText;

@end

NS_ASSUME_NONNULL_END
