//
//  FWRoomViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/2.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWMeetingEnterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWRoomViewModel : NSObject

#pragma mark - 初始化方法
/// 初始化方法
- (instancetype)initWithMeetingEnterModel:(FWMeetingEnterModel *)enterModel;

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 加入房间信息
@property (nonatomic, strong) FWMeetingEnterModel *enterModel;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 操作成功订阅
@property (nonatomic, strong, readonly) RACSubject *succeedSubject;

/// 主持人处理举手请求
/// - Parameters:
/// @param userId 用户标识
/// @param handupType 举手申请类型
/// @param approve 处理举手申请，YES-同意 NO-拒绝
- (void)adminConfirmHandup:(NSString *)userId handupType:(SEAHandupType)handupType approve:(BOOL)approve;

@end

NS_ASSUME_NONNULL_END
