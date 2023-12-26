//
//  FWNetworkBridge.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/7.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWNetworkBridge.h"

/// 请求成功错误码
#define VCSNetworkSucceed 0
/// 测试APPID
NSString * const FWENGINEAPPID = @"b693d5c11888473ea93321e4dac6502b";

@interface FWNetworkBridge ()

/// 网络会话实例
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation FWNetworkBridge

#pragma mark - ------------ 网络组件外部方法 ------------
#pragma mark 获取网络工具对象
/// 获取网络工具对象
+ (FWNetworkBridge *)sharedManager {
    
    static FWNetworkBridge *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[FWNetworkBridge alloc] init];
    });
    return instance;
}

#pragma mark 发起GET请求
/// 发起GET请求
/// - Parameters:
///   - url: 请求接口
///   - params: 请求参数
///   - className: 结果对象
///   - resultBlock: 请求回调
- (void)GET:(NSString *)url params:(nullable NSDictionary *)params className:(nullable NSString *)className resultBlock:(FWNetworkResultBlock)resultBlock {
    
    /// 构建请求参数
    NSDictionary *parameters = [self requestParameters:params];
    /// 发起请求
    [self.sessionManager GET:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        /// 请求进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /// 请求成功
        [self outputlog:YES way:@"GET" api:url params:parameters response:responseObject];
        [self result:responseObject className:className resultBlock:resultBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        /// 请求失败
        [self outputlog:NO way:@"GET" api:url params:parameters response:error];
        if (resultBlock) {
            resultBlock(NO, error, [self networkError:error]);
        }
    }];
}

#pragma mark 发起POST请求
/// 发起POST请求
/// - Parameters:
///   - url: 请求接口
///   - params: 请求参数
///   - className: 结果对象
///   - resultBlock: 请求回调
- (void)POST:(NSString *)url params:(nullable NSDictionary *)params className:(nullable NSString *)className resultBlock:(FWNetworkResultBlock)resultBlock {
    
    /// 构建请求参数
    NSDictionary *parameters = [self requestParameters:params];
    /// 发起请求
    [self.sessionManager POST:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        /// 请求进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /// 请求成功
        [self outputlog:YES way:@"POST" api:url params:parameters response:responseObject];
        [self result:responseObject className:className resultBlock:resultBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        /// 请求失败
        [self outputlog:NO way:@"POST" api:url params:parameters response:error];
        if (resultBlock) {
            resultBlock(NO, error, [self networkError:error]);
        }
    }];
}

#pragma mark - ------------ 网络组件内部方法 ------------
#pragma mark 懒加载网络会话实例
/// 懒加载网络会话实例
- (AFHTTPSessionManager *)sessionManager {
    
    if (!_sessionManager) {
        /// 创建会话实例
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:FWSERVICEURI]];
        /// 设置响应序列化器可接受内容类型
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
        /// 设置请求实体数据的类型(Content-Type: application/json)
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        /// 设置请求实体数据类型请求头信息
        [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        /// 设置请求序列化器请求头信息
        /// [_sessionManager.requestSerializer setValue:RTCENGINEAPPID forHTTPHeaderField:@"app_id"];
        /// 设置请求序列化器请求头信息
        /// [_sessionManager.requestSerializer setValue:VCSAPPID forHTTPHeaderField:@"appid"];
        /// 设置请求序列化器请求头信息
        /// [_sessionManager.requestSerializer setValue:VCSAPPKEY forHTTPHeaderField:@"appkey"];
        /// 设置请求序列化器请求头信息
        /// [_sessionManager.requestSerializer setValue:VCSSIGNATURE forHTTPHeaderField:@"signature"];
        /// 设置请求超时时间
        [_sessionManager.requestSerializer setTimeoutInterval:10.0f];
    }
    return _sessionManager;
}

#pragma mark 构建请求参数
/// 构建请求参数
/// - Parameter params: 请求原始参数
- (NSDictionary *)requestParameters:(NSDictionary *)params {
    
    /// 组装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    /// 添加应用标识
    [parameters setValue:FWENGINEAPPID forKey:@"app_id"];
    /// 添加时间戳
    [parameters setValue:@((NSInteger)[FWDateBridge getNowTimeInterval]) forKey:@"timestamp"];
    /// 添加请求标识
    [parameters setValue:[FWToolBridge getUniqueIdentifier] forKey:@"request_id"];
    /// 添加请求体
    [parameters setValue:params forKey:@"body"];
    
    return parameters;
}

#pragma mark 请求失败描述
/// 请求失败描述
/// - Parameter error: 错误信息
- (NSString *)networkError:(NSError *)error {
    
    NSString *errorMsg = @"网络异常，请稍后再试";
    if (error.code == -1001) {
        /// 请求超时
        errorMsg = @"网络请求超时, 服务器内部错误";
    }
    return errorMsg;
}

#pragma mark 响应结果处理
/// 响应结果处理
/// - Parameters:
///   - responseObject: 响应结果
///   - className: 结果对象
///   - resultBlock: 请求回调
- (void)result:(id)responseObject className:(NSString *)className resultBlock:(FWNetworkResultBlock)resultBlock {
    
    /// 解析请求结果
    NSInteger api_code = [[responseObject objectForKey:@"code"] integerValue];
    /// 解析请求结果描述
    NSString *api_msg = (api_code == VCSNetworkSucceed) ? @"数据请求成功" : [responseObject objectForKey:@"message"];
    
    /// 创建结果临时变量
    id resp = responseObject;
    /// 保护请求对象名称不为空
    if (!kStringIsEmpty(className)) {
        /// 根据名称获取对象类型
        Class class = NSClassFromString(className);
        /// 声明错误信息
        NSError *error;
        /// 构建结果对象
        FWBaseModel *result = [class yy_modelWithDictionary:responseObject];
        /// 如果对象构建成功
        if (!error) {
            /// 赋值结果临时变量
            resp = result;
        }
    }
    /// 回调请求结果
    if (resultBlock) {
        resultBlock((api_code == VCSNetworkSucceed), resp, api_msg);
    }
}

#pragma mark 输出日志
/// 输出日志
/// @param failure 成功or失败
/// @param way 请求方式
/// @param api 连接地址
/// @param params 参数
/// @param responseObject 响应信息
- (void)outputlog:(BOOL)failure way:(NSString *)way api:(NSString *)api params:(NSDictionary *)params response:(id)responseObject {
    
    NSMutableString *debugStr = [NSMutableString string];
    [debugStr appendString:failure ? @"\n+++++***请求成功***+++++\n" : @"\n+++++***请求失败***+++++\n"];
    [debugStr appendString:[NSString stringWithFormat:@"+++++%@请求：%@%@ \n", way, self.sessionManager.baseURL.absoluteString, api]];
    [debugStr appendString:[NSString stringWithFormat:@"+++++请求头参数：%@ \n", self.sessionManager.requestSerializer.HTTPRequestHeaders]];
    [debugStr appendString:[NSString stringWithFormat:@"+++++请求参数：%@ \n", params]];
    [debugStr appendString:[NSString stringWithFormat:@"+++++返回数据：%@ \n", [self UTF8Format:responseObject]]];
    [debugStr appendString:failure ? @"\n+++++***请求成功***+++++\n" : @"\n+++++***请求失败***+++++\n"];
    SGLOG(@"%@", debugStr);
}

#pragma mark 格式化日志数据
- (NSString *)UTF8Format:(NSObject *)object {
    
    if (!object) {
        return @"";
    }
    /// 获取对象的详情描述
    NSString *desc = [object description];
    /// 如果是非错误对象序列化编码响应对象
    if (![object isKindOfClass:[NSError class]]) {
        /// 序列化编码响应对象
        desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    }
    return desc;
}

@end
