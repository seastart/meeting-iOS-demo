//
//  FWNetworkBridge.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/7.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWNetworkBridge.h"

#pragma mark - 错误码表
/// 错误码表
typedef enum : NSUInteger {
    
    /// 无错误
    VCSNetworkCodeOK = 0,
    
    /// 未登录
    VCSNetworkCodeAuthFailed = 10041,
    /// 令牌失效
    VCSNetworkCodeTokenInvalid = 10042,
    /// 令牌过期
    VCSNetworkCodeTokenExpired = 10043
} VCSNetworkCode;

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
    
    /// 获取请求地址
    NSString *baseurl = [self getBaseURL:url];
    /// 发起请求
    [self.sessionManager GET:baseurl parameters:params headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        /// 请求进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /// 处理响应头数据
        [self handleResponseheaders:task];
        /// 请求成功
        [self outputlog:YES way:@"GET" api:baseurl params:params response:responseObject];
        [self result:responseObject className:className resultBlock:resultBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        /// 请求失败
        [self outputlog:NO way:@"GET" api:baseurl params:params response:error];
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
    
    /// 获取请求地址
    NSString *baseurl = [self getBaseURL:url];
    /// 发起请求
    [self.sessionManager POST:baseurl parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        /// 请求进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /// 处理响应头数据
        [self handleResponseheaders:task];
        /// 请求成功
        [self outputlog:YES way:@"POST" api:baseurl params:params response:responseObject];
        [self result:responseObject className:className resultBlock:resultBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        /// 请求失败
        [self outputlog:NO way:@"POST" api:baseurl params:params response:error];
        if (resultBlock) {
            resultBlock(NO, error, [self networkError:error]);
        }
    }];
}

#pragma mark - 设置登录令牌
/// 设置登录令牌
/// - Parameter userToken: 登录令牌
- (void)setUserToken:(NSString *)userToken {
    
    /// 设置请求头信息
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", userToken] forHTTPHeaderField:@"Authorization"];
}

#pragma mark - 清除登录令牌
/// 清除登录令牌
- (void)clearUserToken {
    
    /// 重置请求头信息
    [self.sessionManager.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
}

#pragma mark - ------------ 网络组件内部方法 ------------
#pragma mark 懒加载网络会话实例
/// 懒加载网络会话实例
- (AFHTTPSessionManager *)sessionManager {
    
    if (!_sessionManager) {
        /// 创建会话实例
        _sessionManager = [AFHTTPSessionManager manager];
        /// 设置响应序列化器可接受内容类型
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
        /// 设置请求实体数据的类型(Content-Type: application/json)
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        /// 设置请求验证请求头信息
        [_sessionManager.requestSerializer setValue:@"Bearer" forHTTPHeaderField:@"Authorization"];
        /// 设置请求实体数据类型请求头信息
        [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        /// 设置请求超时时间
        [_sessionManager.requestSerializer setTimeoutInterval:20.0f];
    }
    return _sessionManager;
}

#pragma mark 获取请求地址
/// 获取请求地址
/// - Parameter url: 短链接
- (NSString *)getBaseURL:(NSString *)url {
    
    /// 获取主机地址
    NSString *host = FWSERVICEURI;
    /// 构建请求地址
    NSString *baseurl = [NSString stringWithFormat:@"%@%@%@", host, FWSERVICESHORTHEADER, url];
    /// 请求地址编码处理
    baseurl = [baseurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    /// 返回请求地址
    return baseurl;
}

#pragma mark 响应结果处理
/// 响应结果处理
/// - Parameters:
///   - responseObject: 响应结果
///   - className: 结果对象
///   - resultBlock: 请求回调
- (void)result:(id)responseObject className:(NSString *)className resultBlock:(FWNetworkResultBlock)resultBlock {
    
    /// 解析请求结果
    NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
    /// 解析请求结果描述
    NSString *message = (code == VCSNetworkCodeOK) ? @"数据请求成功" : [responseObject objectForKey:@"msg"];
    
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
    
    /// 令牌失效或过期需要用户重新登录
    if (code == VCSNetworkCodeAuthFailed || code == VCSNetworkCodeTokenInvalid || code == VCSNetworkCodeTokenExpired) {
        /// 鉴权令牌失效提示弹窗
        [self tokenInvalidAlert];
    }
    
    /// 回调请求结果
    if (resultBlock) {
        resultBlock((code == VCSNetworkCodeOK), resp, message);
    }
}

#pragma mark 处理响应头数据
/// 处理响应头数据
/// - Parameter task: 请求任务
- (void)handleResponseheaders:(NSURLSessionDataTask *)task {
    
    /// 判别响应数据类型
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        /// 转换接口响应信息
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        /// 获取所有的响应头数据
        NSDictionary *headers = [httpResponse allHeaderFields];
        /// 判断响应头中是否存在新令牌对象
        if ([headers.allKeys containsObject:@"new-token"]) {
            /// 获取新令牌
            NSString *token = [headers objectForKey:@"new-token"];
            /// 更新用户令牌
            [[FWStoreDataBridge sharedManager] updateAuthToken:token];
        }
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
    [debugStr appendString:[NSString stringWithFormat:@"+++++%@请求：%@ \n", way, api]];
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

#pragma mark 请求失败描述
/// 请求失败描述
/// - Parameter error: 错误信息
- (NSString *)networkError:(NSError *)error {
    
    /// 声明描述
    NSString *errorMsg = @"网络请求失败，请稍后再试";
    /// 根据错误码设置描述
    if (error.code == -999) {
        /// 请求取消
        errorMsg = @"网络请求已取消";
    } else if (error.code == -1001) {
        /// 请求超时
        errorMsg = @"网络请求超时";
    } else {
        /// 错误信息
        errorMsg = error.description;
    }
    return errorMsg;
}

#pragma mark 鉴权令牌失效提示弹窗
/// 鉴权令牌失效提示弹窗
- (void)tokenInvalidAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"登录已失效，请您重新登录。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        /// 会议组件登出
        [[MeetingKit sharedInstance] logout:nil onFailed:nil];
        /// 本地退出登录
        [[FWStoreDataBridge sharedManager] logout];
        /// 切换登录视图
        [[FWEntryBridge sharedManager] changeLoginView];
    }];
    [alert addAction:cancelAction];
    [[FWEntryBridge sharedManager].appDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
