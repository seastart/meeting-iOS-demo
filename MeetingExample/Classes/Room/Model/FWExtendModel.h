//
//  FWExtendModel.h
//  MeetingExample
//
//  Created by SailorGa on 2024/7/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 用户props扩展
@interface FWUserExtendModel : NSObject

/// 用户角色
@property (nonatomic, assign) SEAUserRole role;
/// 麦克风状态
@property (nonatomic, assign) SEADeviceState micState;
/// 摄像头状态
@property (nonatomic, assign) SEADeviceState cameraState;
/// 共享状态
@property (nonatomic, assign) SEAShareType shareState;
/// 是否被踢出
@property (nonatomic, assign) BOOL isKickout;
/// 聊天能力禁用状态，YES-禁用 NO-不禁用
@property (nonatomic, assign) BOOL chatDisabled;
/// 用户头像
@property (nonatomic, copy) NSString *avatarUrl;
/// 扩展信息
@property (nonatomic, copy) NSString *extendInfo;

@end


/// 房间props扩展
@interface FWRoomExtendModel : NSObject

/// 会议标识
@property (nonatomic, copy) NSString *meetingId;
/// 房间号码
@property (nonatomic, copy) NSString *roomNo;
/// 房间标识
@property (nonatomic, copy) NSString *roomId;
/// 会议标题
@property (nonatomic, copy) NSString *title;
/// 会议说明
@property (nonatomic, copy) NSString *content;
/// 会议类型
@property (nonatomic, assign) SEAMeetingType meetingType;
/// 开始时间
@property (nonatomic, assign) NSInteger beginTime;
/// 结束时间
@property (nonatomic, assign) NSInteger endTime;
/// 入会静音状态
@property (nonatomic, assign) SEAMeetingMuteState entryMutePolicy;
/// 房间水印禁用状态，YES-禁用 NO-不禁用
@property (nonatomic, assign) BOOL watermarkDisabled;
/// 房间截屏禁用状态，YES-禁用 NO-不禁用
@property (nonatomic, assign) BOOL screenshotDisabled;
/// 共享类型
@property (nonatomic, assign) SEAShareType shareType;
/// 共享者标识
@property (nonatomic, copy) NSString *shareUid;
/// 是否允许自我解除麦克风的禁用状态，YES-禁用 NO-不禁用
@property (nonatomic, assign) BOOL selfUnmuteMicDisabled;
/// 是否允许自我解除摄像头的禁用状态，YES-禁用 NO-不禁用
@property (nonatomic, assign) BOOL selfUnmuteCameraDisabled;
/// 麦克风禁用状态，YES-禁用 NO-不禁用
@property (nonatomic, assign) BOOL micDisabled;
/// 摄像头禁用状态，YES-禁用 NO-不禁用
@property (nonatomic, assign) BOOL cameraDisabled;
/// 聊天能力禁用状态，YES-禁用 NO-不禁用
@property (nonatomic, assign) BOOL chatDisabled;
/// 锁定状态，YES-开启 NO-关闭
@property (nonatomic, assign) BOOL locked;
/// 创建者标识
@property (nonatomic, copy) NSString *creator;
/// 主持人标识
@property (nonatomic, copy) NSString *hostUid;
/// 扩展信息
@property (nonatomic, copy) NSString *extendInfo;

@end

NS_ASSUME_NONNULL_END
