//
//  FWBuglyBridge.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/13.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWBuglyBridge.h"

@interface FWBuglyBridge () <BuglyDelegate>

/// Bugly配置
@property (nonatomic, strong) BuglyConfig *buglyConfig;

@end

@implementation FWBuglyBridge

#pragma mark - 获取单例工具类
/// 获取单例工具类
+ (FWBuglyBridge *)sharedManager {
    
    static FWBuglyBridge *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FWBuglyBridge alloc] init];
    });
    return manager;
}

#pragma mark - 懒加载Bugly配置
- (BuglyConfig *)buglyConfig {
    
    if (!_buglyConfig) {
        /// 初始化Bugly配置
        _buglyConfig = [[BuglyConfig alloc] init];
        /// 设置代理回调
        _buglyConfig.delegate = self;
        /// 设置自定义版本号
        _buglyConfig.version = [NSString stringWithFormat:@"%@-%@", BundleShortVersion, BundleVersion];
        /// 设置自定义设备唯一标识
        _buglyConfig.deviceIdentifier = [FWToolBridge getIdentifierForVendor];
        /// 设置卡顿监控开关
        _buglyConfig.blockMonitorEnable = YES;
        /// 设置卡顿监控判断间隔
        _buglyConfig.blockMonitorTimeout = 1;
        /// 设置自定义日志上报的级别，默认不上报自定义日志
        _buglyConfig.reportLogLevel = BuglyLogLevelError;
        /// 设置非正常退出事件记录开关
        _buglyConfig.unexpectedTerminatingDetectionEnable = YES;
    }
    return _buglyConfig;
}

#pragma mark - 初始化Bugly
/// 初始化Bugly
- (void)initBugly {
    
    /// 默认渠道标识AppStore
    NSString *channel = @"AppStore版本";
    /// 设置自定义渠道标识release、adhoc、debug
    switch ([FWToolBridge getApplicationCertificate]) {
        case FWCertificateStateDebug:
            /// Debug版本设置渠道标识为Debug
            channel = @"Debug版本";
            break;
        case FWCertificateStateAdhoc:
            /// Adhoc版本设置渠道标识为Adhoc
            channel = @"Adhoc版本";
            break;
        case FWCertificateStateAppStore:
            /// AppStore版本设置渠道标识为AppStore
            channel = @"AppStore版本";
            break;
        default:
            break;
    }
    /// 设置渠道标识
    self.buglyConfig.channel = channel;
    /// 指定配置初始化Bugly
    [Bugly startWithAppId:FWBUGLYAPPID config:self.buglyConfig];
}

#pragma mark - ------- BuglyDelegate的代理方法 -------
#pragma mark 发生异常时回调
/// 发生异常时回调
/// @param exception 异常信息
- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception {
    
    return @"发生异常";
}

#pragma mark 发生SIGKILL时回调
/// 发生SIGKILL时回调
- (NSString * BLY_NULLABLE)attachmentForSigkill {
    
    return @"发生SIGKILL";
}

#pragma mark 策略激活时回调
/// 策略激活时回调
/// @param tacticInfo 策略信息
- (BOOL)h5AlertForTactic:(NSDictionary *)tacticInfo {
    
    return NO;
}

@end
