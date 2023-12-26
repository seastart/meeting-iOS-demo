//
//  FWDateBridge.h
//  MeetingExample
//
//  Created by SailorGa on 2023/2/28.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWDateBridge : NSObject

#pragma mark - 转化类
/// 字符串 转 NSDate
/// @param str 转化字符串
/// @param format 时间格式 例如 YYYY-MM-dd HH:mm:ss
+ (NSDate *)stringConversionNSDate:(NSString *)str format:(NSString *)format;

#pragma mark 字符串 转 时间戳
/// 字符串 转 时间戳
/// @param str 转化字符串
/// @param format 时间格式 例如 YYYY-MM-dd HH:mm:ss
+ (NSInteger)stringConversionTimeStamp:(NSString *)str format:(NSString *)format;

#pragma mark NSDate 转 字符串
/// NSDate 转 字符串
/// @param date 转化时间
/// @param format 时间格式 例如 YYYY-MM-dd HH:mm:ss
+ (NSString *)dateConversionNSString:(NSDate *)date format:(NSString *)format;

#pragma mark 时间戳 转 字符串
/// 时间戳 转 字符串
/// @param timeStamp 转化时间戳
/// @param format 时间格式 例如 YYYY-MM-dd HH:mm:ss
+ (NSString *)timeStampConversionNSString:(NSInteger)timeStamp format:(NSString *)format;

#pragma mark NSDate 转 时间戳
/// NSDate 转 时间戳
/// @param date 转化时间
+ (NSInteger)dateConversionTimeStamp:(NSDate *)date;

#pragma mark 时间戳 转 NSDate
/// 时间戳 转 NSDate
/// @param timeStamp 转化时间戳
+ (NSDate *)timeStampConversionNSDate:(NSInteger)timeStamp;


#pragma mark - 获取类
#pragma mark 获取当前时间戳
/// 获取当前时间戳
+ (NSTimeInterval)getNowTimeInterval;

#pragma mark 获取明天时间戳
/// 获取明天时间戳
+ (NSTimeInterval)getTomorrowDay;

#pragma mark 获取目标 NSDate 年份
/// 获取目标 NSDate 年份
/// @param targetDate 目标时间
+ (NSInteger)getTargetDateYear:(NSDate *)targetDate;

#pragma mark 获取目标 NSDate 月份
/// 获取目标 NSDate 月份
/// @param targetDate 目标时间
+ (NSInteger)getTargetDateMonth:(NSDate *)targetDate;

#pragma mark 获取目标 NSDate 日期
/// 获取目标 NSDate 日期
/// @param targetDate 目标时间
+ (NSInteger)getTargetDateDay:(NSDate *)targetDate;

#pragma mark 获取目标 NSDate 星期
/// 获取目标 NSDate 星期
/// @param targetDate 目标时间
+ (NSString *)getTargetDateWeek:(NSDate *)targetDate;

#pragma mark 获取目标 NSDate 小时
/// 获取目标 NSDate 小时
/// @param targetDate 目标时间
+ (NSInteger)getTargetDateHour:(NSDate *)targetDate;

#pragma mark 获取目标 NSDate 分钟
/// 获取目标 NSDate 分钟
/// @param targetDate 目标时间
+ (NSInteger)getTargetDateMinute:(NSDate *)targetDate;

#pragma mark 获取目标 NSDate 秒数
/// 获取目标 NSDate 秒数
/// @param targetDate 目标时间
+ (NSInteger)getTargetDateSeconds:(NSDate *)targetDate;

#pragma mark 获取某年某月的天数
/// 获取某年某月的天数
/// @param year 目标年份
/// @param month 目标月份
+ (NSInteger)getDayInThisYear:(NSInteger)year withMonth:(NSInteger)month;

#pragma mark - 计算某个时间距离今天的时间
/// 计算某个时间距离今天的时间
/// @param timeStamp 时间戳
+ (NSString *)rangeTimeStampString:(NSInteger)timeStamp;

@end

NS_ASSUME_NONNULL_END
