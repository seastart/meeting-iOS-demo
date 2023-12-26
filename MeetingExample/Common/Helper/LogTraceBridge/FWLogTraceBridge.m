//
//  FWLogTraceBridge.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/13.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWLogTraceBridge.h"
#import <sys/mman.h>
#import <sys/stat.h>

@interface FWLogTraceBridge ()

/// 是否启用日志文件系统
@property (assign, nonatomic) BOOL LogFileEnabled;
/// 日志文件夹路径
@property (copy, nonatomic) NSString *logsDirectory;
/// 当前日志文件路径
@property (copy, nonatomic) NSString *logFilePath;

/// 记录原来的定向位置
@property (assign, nonatomic) int stdoutDup;
@property (assign, nonatomic) int stderrDup;

@end

@implementation FWLogTraceBridge

#pragma mark - 初始化获取单例
/// 初始化获取单例
+ (FWLogTraceBridge *)sharedManager {
    
    static FWLogTraceBridge *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FWLogTraceBridge alloc] init];
    });
    return manager;
}

#pragma mark - 开启日志文件系统
/// 开启日志文件系统
- (void)enableFileLogSystem {
    
    self.LogFileEnabled = YES;
    
    /// 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    self.logsDirectory = [documentDirectory stringByAppendingPathComponent:@"Logs"];
    /// 文件保护等级
    NSDictionary *attribute = [NSDictionary dictionaryWithObject:NSFileProtectionNone forKey:NSFileProtectionKey];
    [[NSFileManager defaultManager] createDirectoryAtPath:self.logsDirectory withIntermediateDirectories:YES attributes:attribute error:nil];
    /// 每次调用都新创建一个文件用于切片
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    self.logFilePath = [self.logsDirectory stringByAppendingFormat:@"/%@.log", dateStr];
    /// 记录原来的定向位置
    self.stdoutDup = dup(STDOUT_FILENO);
    self.stderrDup = dup(STDERR_FILENO);
    /// 将log重定向到文件
    freopen([self.logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([self.logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

#pragma mark - 获取日志文件夹路径
/// 获取日志文件夹路径
- (NSString *)getLogsDirectory {
    
    if (self.LogFileEnabled && !kStringIsEmpty(self.logsDirectory)) {
        return self.logsDirectory;
    } else {
        return @"";
    }
}

#pragma mark - 获取日志压缩文件目录
/// 获取日志压缩文件目录
- (NSString *)getZipArchiveLogFilePath {
    
    /// 获取Document目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    /// 此处使用NSString
    NSString *fileName = [NSString stringWithFormat:@"SRTCLogs.zip"];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    return logFilePath;
}

#pragma mark - 删除日志文件
/// 删除日志文件
- (void)clearFileLog {
    
    if (!kStringIsEmpty([self getLogsDirectory])) {
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[self getLogsDirectory] error:&error];
    }
    if (!kStringIsEmpty([self getZipArchiveLogFilePath])) {
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[self getZipArchiveLogFilePath] error:&error];
    }
    /// 将log重定向恢复到控制台
    dup2(self.stdoutDup, STDOUT_FILENO);
    dup2(self.stderrDup, STDERR_FILENO);
}

#pragma mark - 删除日志文件压缩包
/// 删除日志文件压缩包
- (void)clearZipFileLog {
    
    if (!kStringIsEmpty([self getZipArchiveLogFilePath])) {
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[self getZipArchiveLogFilePath] error:&error];
    }
}

#pragma mark - 停止Log系统，并清除日志文件
/// 停止Log系统，并清除日志文件
- (void)stopLog {
    
    [self clearFileLog];
    self.LogFileEnabled = NO;
}

@end
