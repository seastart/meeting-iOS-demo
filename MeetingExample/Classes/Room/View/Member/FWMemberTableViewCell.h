//
//  FWMemberTableViewCell.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/4.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 成员移除事件回调
typedef void(^FWMemberTableViewCellRemoveBlock)(NSString *nickname);

@interface FWMemberTableViewCell : UITableViewCell

/// 创建Table View Cell
/// - Parameter tableView: Table View
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/// 设置项目内容
/// - Parameters:
///   - avatarUrl: 头像地址
///   - nicknameText: 昵称
///   - isOwner: 是否是主持人
///   - oneself: 是否是自己
///   - videoState: 视频状态
///   - audioState: 音频状态
///   - removeBlock: 成员移除事件回调
- (void)setupWithAvatarUrl:(NSString *)avatarUrl nicknameText:(NSString *)nicknameText isOwner:(BOOL)isOwner oneself:(BOOL)oneself videoState:(BOOL)videoState audioState:(BOOL)audioState removeBlock:(FWMemberTableViewCellRemoveBlock)removeBlock;

@end

NS_ASSUME_NONNULL_END
