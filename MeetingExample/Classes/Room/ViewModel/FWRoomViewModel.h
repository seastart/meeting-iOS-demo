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

@end

NS_ASSUME_NONNULL_END
