//
//  FWInterfaces.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/7.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 数据请求短链接头部
FOUNDATION_EXTERN NSString *__nonnull const FWSERVICESHORTHEADER;
/// 获取用户签名
FOUNDATION_EXTERN NSString *__nonnull const FWSIGNATUREINFOFACE;
/// 退出签名用户
FOUNDATION_EXTERN NSString *__nonnull const FWUSERLOGOUT;

@interface FWInterfaces : NSObject

@end

NS_ASSUME_NONNULL_END
