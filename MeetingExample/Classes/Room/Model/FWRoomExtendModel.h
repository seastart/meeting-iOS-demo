//
//  FWRoomExtendModel.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/14.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWRoomExtendModel : NSObject

/// 共享状态(none|desktop|whiteboard)
@property (nonatomic, strong) NSString *shareState;
/// 共享成员
@property (nonatomic, strong) NSString *shareUid;
/// 共享轨道
@property (nonatomic, assign) int shareTrack;

@end

NS_ASSUME_NONNULL_END
