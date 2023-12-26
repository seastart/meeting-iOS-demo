//
//  FWRoomMemberCollectionViewCell.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/2.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FWRoomMemberModel;

@interface FWRoomMemberCollectionViewCell : UICollectionViewCell

/// 窗口关联成员信息
@property (nonatomic, strong, nullable) FWRoomMemberModel *memberModel;

/// 重新订阅轨道
- (void)reloadSubscribe;

@end

NS_ASSUME_NONNULL_END
