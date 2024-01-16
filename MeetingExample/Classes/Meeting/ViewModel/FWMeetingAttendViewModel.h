//
//  FWMeetingAttendViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2024/1/16.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWMeetingAttendViewModel : NSObject

#pragma mark - 初始化方法
/// 初始化方法
/// @param type 参会入口类型
- (instancetype)initWithType:(FWMeetingEntryType)type;

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 参会入口类型
@property (nonatomic, assign) FWMeetingEntryType type;
/// 房间号码
@property (nonatomic, copy) NSString *roomnoText;
/// 用户昵称
@property (nonatomic, copy) NSString *nicknameText;

/// 参会麦克风开关，YES-开启 NO-关闭
@property (assign, nonatomic) BOOL isMicrophone;
/// 参会摄像头开关，YES-开启 NO-关闭
@property (assign, nonatomic) BOOL isCamera;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 成功订阅
@property (nonatomic, strong, readonly) RACSubject *succeedSubject;

/// 复制房间号码
- (void)onCopyRoomNo;

/// 请求确定
- (void)onConfirmEvent;

@end

NS_ASSUME_NONNULL_END
