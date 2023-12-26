//
//  FWRoomStatusView.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/1.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FWRoomMemberModel;

@interface FWRoomStatusView : UIView

#pragma mark - 设置/更新成员信息
/// 设置/更新成员信息
/// - Parameter userModel: 成员信息
- (void)setupMemberInfoWithUserModel:(FWRoomMemberModel *)userModel;

@end

NS_ASSUME_NONNULL_END
