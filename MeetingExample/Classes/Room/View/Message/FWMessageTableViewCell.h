//
//  FWMessageTableViewCell.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/2.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWMessageTableViewCell : UITableViewCell

#pragma mark - 初始化Cell
/// 初始化Cell
/// - Parameter tableView: tableView
+ (instancetype)cellWithTableView:(UITableView *)tableView;

#pragma mark - 设置显示内容
/// 设置显示内容
/// - Parameters:
///   - nameText: 用户昵称
///   - messageText: 消息内容
///   - avatarUrl: 头像地址
- (void)setupConfig:(NSString *)nameText messageText:(NSString *)messageText avatarUrl:(nullable NSString *)avatarUrl;

@end

NS_ASSUME_NONNULL_END
