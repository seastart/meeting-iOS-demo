//
//  FWExtendModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/7/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWExtendModel.h"

/// 用户props扩展
@implementation FWUserExtendModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"micState" : @"mic_state", @"cameraState" : @"camera_state", @"shareState" : @"share_state", @"isKickout" : @"is_kickout", @"chatDisabled" : @"chat_disabled", @"micDisabled" : @"mic_disabled", @"cameraDisabled" : @"camera_disabled", @"extendInfo" : @"extend_info"};
}

@end

/// 房间props扩展
@implementation FWRoomExtendModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"meetingId" : @"id", @"roomNo" : @"room_no", @"meetingType" : @"meeting_type", @"beginTime" : @"begin_time", @"endTime" : @"end_time", @"entryMutePolicy" : @"entry_mute_policy", @"watermarkDisabled" : @"watermark_disabled", @"screenshotDisabled" : @"screenshot_disabled", @"shareType" : @"share_state", @"shareUid" : @"share_uid", @"selfUnmuteMicDisabled" : @"self_unmute_mic_disabled", @"selfUnmuteCameraDisabled" : @"self_unmute_camera_disabled", @"micDisabled" : @"mic_disabled", @"cameraDisabled" : @"camera_disabled", @"chatDisabled" : @"chat_disabled", @"extendInfo" : @"extend_info"};
}

@end
