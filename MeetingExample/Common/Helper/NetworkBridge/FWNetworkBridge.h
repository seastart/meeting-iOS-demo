//
//  FWNetworkBridge.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/7.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 请求结果回调
typedef void (^FWNetworkResultBlock)(BOOL result, id _Nullable data, NSString * _Nullable errorMsg);

@interface FWNetworkBridge : NSObject

#pragma mark - 获取网络工具对象
/// 获取网络工具对象
+ (FWNetworkBridge *)sharedManager;

#pragma mark - 发起GET请求
/// 发起GET请求
/// - Parameters:
///   - url: 请求接口
///   - params: 请求参数
///   - className: 结果对象
///   - resultBlock: 请求回调
- (void)GET:(NSString *)url params:(nullable NSDictionary *)params className:(nullable NSString *)className resultBlock:(FWNetworkResultBlock)resultBlock;

#pragma mark - 发起POST请求
/// 发起POST请求
/// - Parameters:
///   - url: 请求接口
///   - params: 请求参数
///   - className: 结果对象
///   - resultBlock: 请求回调
- (void)POST:(NSString *)url params:(nullable NSDictionary *)params className:(nullable NSString *)className resultBlock:(FWNetworkResultBlock)resultBlock;

#pragma mark - 设置登录令牌
/// 设置登录令牌
/// - Parameter userToken: 登录令牌
- (void)setUserToken:(NSString *)userToken;

#pragma mark - 清除登录令牌
/// 清除登录令牌
- (void)clearUserToken;

@end

NS_ASSUME_NONNULL_END
