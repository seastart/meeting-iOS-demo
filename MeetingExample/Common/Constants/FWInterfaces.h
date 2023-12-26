//
//  FWInterfaces.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/7.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 默认服务器地址
/// 默认服务器地址
FOUNDATION_EXTERN NSString *__nonnull const FWSERVICEURI;

#pragma mark - 获取用户签名
/// 获取用户签名
FOUNDATION_EXTERN NSString *__nonnull const FWSIGNATUREINFOFACE;

@interface FWInterfaces : NSObject

@end

NS_ASSUME_NONNULL_END
