//
//  FWMeetingEntryViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2024/1/16.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWMeetingEntryViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 成功订阅
@property (nonatomic, strong, readonly) RACSubject *succeedSubject;

/// 创建房间
/// - Parameter title: 房间标题
- (void)createRoom:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
