//
//  FWMemberTableViewCell.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/4.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 成员麦克风事件回调
typedef void(^FWMemberTableViewCellMicrophoneBlock)(NSInteger index);
/// 成员摄像头事件回调
typedef void(^FWMemberTableViewCellCameraBlock)(NSInteger index);
/// 成员移除事件回调
typedef void(^FWMemberTableViewCellRemoveBlock)(NSString *userId, NSString *nickname);

@interface FWMemberTableViewCell : UITableViewCell

/// 创建Table View Cell
/// - Parameter tableView: Table View
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/// 设置项目内容
/// - Parameters:
///   - userId: 用户标识
///   - avatarUrl: 头像地址
///   - nicknameText: 昵称
///   - isOwner: 是否是主持人
///   - isMine: 是否是自己
///   - videoState: 视频状态
///   - audioState: 音频状态
///   - index: 成员索引
///   - microphoneBlock: 成员麦克风事件回调
///   - cameraBlock: 成员摄像头事件回调
///   - removeBlock: 成员移除事件回调
- (void)setupWithUserId:(NSString *)userId avatarUrl:(NSString *)avatarUrl nicknameText:(NSString *)nicknameText isOwner:(BOOL)isOwner isMine:(BOOL)isMine videoState:(BOOL)videoState audioState:(BOOL)audioState index:(NSInteger)index microphoneBlock:(FWMemberTableViewCellMicrophoneBlock)microphoneBlock cameraBlock:(FWMemberTableViewCellCameraBlock)cameraBlock removeBlock:(FWMemberTableViewCellRemoveBlock)removeBlock;

@end

NS_ASSUME_NONNULL_END
