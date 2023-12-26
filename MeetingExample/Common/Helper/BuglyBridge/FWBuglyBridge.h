//
//  FWBuglyBridge.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/13.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWBuglyBridge : NSObject

#pragma mark - 获取单例工具类
/// 获取单例工具类
+ (FWBuglyBridge *)sharedManager;

#pragma mark - 初始化Bugly
/// 初始化Bugly
- (void)initBugly;

@end

NS_ASSUME_NONNULL_END
