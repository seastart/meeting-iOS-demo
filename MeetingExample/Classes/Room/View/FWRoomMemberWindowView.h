//
//  FWRoomMemberWindowView.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/19.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FWRoomMemberWindowView;
@class FWRoomMemberModel;

@protocol FWRoomMemberWindowViewDelegate <NSObject>

#pragma mark 成员选择回调
/// 成员选择回调
/// @param windowView 成员视图对象
/// @param userId 成员标识
/// @param memberModel 成员信息
- (void)windowView:(FWRoomMemberWindowView *)windowView didSelectItemAtUserId:(NSString *)userId memberModel:(FWRoomMemberModel *)memberModel;

@end

@interface FWRoomMemberWindowView : UIView

/// 回调代理
@property (nonatomic, weak) id <FWRoomMemberWindowViewDelegate> delegate;
/// 窗口关联成员信息
@property (nonatomic, strong, nullable) FWRoomMemberModel *memberModel;
/// 窗口关联成员标识
@property (nonatomic, strong, nullable) NSString *userId;

@end

NS_ASSUME_NONNULL_END
