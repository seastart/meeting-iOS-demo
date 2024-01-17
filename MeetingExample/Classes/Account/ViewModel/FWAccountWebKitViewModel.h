//
//  FWAccountWebKitViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2024/1/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWAccountWebKitViewModel : NSObject

#pragma mark - 初始化方法
/// 初始化方法
/// @param type 网页加载类型
- (instancetype)initWithType:(FWAccountWebType)type;

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 网页加载类型
@property (nonatomic, assign) FWAccountWebType type;

@end

NS_ASSUME_NONNULL_END
