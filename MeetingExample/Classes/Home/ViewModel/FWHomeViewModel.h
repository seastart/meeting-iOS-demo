//
//  FWHomeViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2021/10/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWHomeViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;

@end

NS_ASSUME_NONNULL_END
