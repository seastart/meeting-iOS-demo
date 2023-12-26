//
//  FWLogTraceBridge.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/13.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWLogTraceBridge : NSObject

#pragma mark - 初始化获取单例
/// 初始化获取单例
+ (FWLogTraceBridge *)sharedManager;

#pragma mark - 开启日志文件系统
/// 开启日志文件系统
- (void)enableFileLogSystem;

#pragma mark - 获取日志文件夹路径
/// 获取日志文件夹路径
- (NSString *)getLogsDirectory;

#pragma mark - 获取日志压缩文件目录
/// 获取日志压缩文件目录
- (NSString *)getZipArchiveLogFilePath;

#pragma mark - 删除日志文件
/// 删除日志文件
- (void)clearFileLog;

#pragma mark - 删除日志文件压缩包
/// 删除日志文件压缩包
- (void)clearZipFileLog;

/// 停止所有Log系统，并清除日志文件
- (void)stopLog;

@end

NS_ASSUME_NONNULL_END
