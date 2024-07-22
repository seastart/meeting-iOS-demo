//
//  FWMeetingEnterModel.h
//  MeetingExample
//
//  Created by SailorGa on 2024/4/25.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWMeetingEnterModel : NSObject

/// 房间号码
@property (nonatomic, copy) NSString *roomNo;
/// 参会昵称
@property (nonatomic, copy) NSString *nickname;
/// 参会头像
@property (nonatomic, copy) NSString *avatar;
/// 视频状态，YES-开启 NO-关闭 默认NO
@property (nonatomic, assign) BOOL videoState;
/// 音频状态，YES-开启 NO-关闭 默认NO
@property (nonatomic, assign) BOOL audioState;

@end

NS_ASSUME_NONNULL_END
