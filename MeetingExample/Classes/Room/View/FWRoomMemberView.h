//
//  FWRoomMemberView.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/2.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FWRoomMemberView;
@class FWRoomMemberModel;

@protocol FWRoomMemberViewDelegate <NSObject>

#pragma mark 成员选择回调
/// 成员选择回调
/// @param memberView 成员列表对象
/// @param indexPath 选中索引
/// @param memberModel 成员信息
- (void)memberView:(FWRoomMemberView *)memberView didSelectItemAtIndexPath:(NSIndexPath *)indexPath memberModel:(FWRoomMemberModel *)memberModel;

@end

@interface FWRoomMemberView : UICollectionView

/// 回调代理
@property (nonatomic, weak) IBOutlet id <FWRoomMemberViewDelegate> mDelegate;

#pragma mark - 成员更新信息
/// 成员更新信息
/// @param userId 成员ID
- (void)memberUpdateWithUserId:(NSString *)userId;

#pragma mark - 成员离开房间
/// 成员离开房间
/// @param userId 成员ID
- (void)memberExitWithUserId:(NSString *)userId;

#pragma mark - 订阅成员视频流
/// 订阅成员视频流
/// @param memberModel 成员信息
/// @param trackId 轨道标识
/// @param subscribe 订阅状态
//- (void)subscribeWithMemberModel:(FWRoomMemberModel *)memberModel trackId:(RTCTrackIdentifierFlags)trackId subscribe:(BOOL)subscribe;

@end

NS_ASSUME_NONNULL_END
