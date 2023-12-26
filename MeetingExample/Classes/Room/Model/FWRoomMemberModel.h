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
/// 对该成员视频流的订阅状态(YES-订阅 NO-未订阅)
@property (nonatomic, assign) BOOL subscribe;
/// 订阅的轨道标识
//@property (nonatomic, assign) RTCTrackIdentifierFlags trackIdentifier;

@end

NS_ASSUME_NONNULL_END
