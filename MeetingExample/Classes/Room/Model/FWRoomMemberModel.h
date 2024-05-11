//
//  FWRoomMemberModel.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/2.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWRoomMemberModel : NSObject

/// 用户标识
@property (nonatomic, copy) NSString *uid;
/// 是否为自己
@property (nonatomic, assign) BOOL isMine;
/// 是否在共享
@property (nonatomic, assign) BOOL isSharing;
/// 是否订阅
@property (nonatomic, assign) BOOL subscribe;
/// 进入时间
@property (nonatomic, strong) NSDate *enterDate;

@end

NS_ASSUME_NONNULL_END
