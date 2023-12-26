//
//  FWDateBridge.m
//  MeetingExample
//
//  Created by SailorGa on 2023/2/28.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWDateBridge.h"

/// 所有星期
#define FWDateWeekDays [NSArray arrayWithObjects:[NSNull null], NSLocalizedString(@"周日", nil), NSLocalizedString(@"周一", nil), NSLocalizedString(@"周二", nil), NSLocalizedString(@"周三", nil), NSLocalizedString(@"周四", nil), NSLocalizedString(@"周五", nil), NSLocalizedString(@"周六", nil), nil]

@implementation FWDateBridge

#pragma mark - 转化类
/// 字符串 转 NSDate
/// @param str 转化字符串
/// @param format 时间格式 例如 YYYY-MM-dd HH:mm:ss
+ (NSDate *)stringConversionNSDate:(NSString *)str format:(NSString *)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:str];
}

#pragma mark 字符串 转 时间戳
/// 字符串 转 时间戳
/// @param str 转化字符串
/// @param format 时间格式 例如 YYYY-MM-dd HH:mm:ss
+ (NSInteger)stringConversionTimeStamp:(NSString *)str format:(NSString *)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *tempDate = [dateFormatter dateFromString:str];
    return [tempDate timeIntervalSince1970];
}

#pragma mark NSDate 转 字符串
/// NSDate 转 字符串
/// @param date 转化时间
/// @param format 时间格式 例如 YYYY-MM-dd HH:mm:ss
+ (NSString *)dateConversionNSString:(NSDate *)date format:(NSString *)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

#pragma mark 时间戳 转 字符串
/// 时间戳 转 字符串
/// @param timeStamp 转化时间戳
/// @param format 时间格式 例如 YYYY-MM-dd HH:mm:ss
+ (NSString *)timeStampConversionNSString:(NSInteger)timeStamp format:(NSString *)format {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

#pragma mark NSDate 转 时间戳
/// NSDate 转 时间戳
/// @param date 转化时间
+ (NSInteger)dateConversionTimeStamp:(NSDate *)date {
    
    return [date timeIntervalSince1970];
}

#pragma mark 时间戳 转 NSDate
/// 时间戳 转 NSDate
/// @param timeStamp 转化时间戳
+ (NSDate *)timeStampConversionNSDate:(NSInteger)timeStamp {
    
    return [NSDate dateWithTimeIntervalSince1970:timeStamp];
}


#pragma mark - 获取类
#pragma mark 获取当前时间戳
/// 获取当前时间戳
+ (NSTimeInterval)getNowTimeInterval {
    
    return [[NSDate date] timeIntervalSince1970];
}

#pragma mark 获取明天时间戳
/// 获取明天时间戳
+ (NSTimeInterval)getTomorrowDay {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday |NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    [components setDay:([components day] + 1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    return [beginningOfWeek timeIntervalSince1970];
}

#pragma mark 获取目标 NSDate 年份
/// 获取目标 NSDate 年份
/// @param targetDate 目标时间
+ (NSInteger)getTargetDateYear:(NSDate *)targetDate {
    
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:targetDate].year;
}

#pragma mark 获取目标 NSDate 月份
/// 获取目标 NSDate 月份
/// @param targetDate 目标时间
+ (NSInteger)getTargetDateMonth:(NSDate *)targetDate {
    
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:targetDate].month;
}

#pragma mark 获取目标 NSDate 日期
/// 获取目标 NSDate 日期
/// @param targetDate 目标时间
+ (NSInteger)getTargetDateDay:(NSDate *)targetDate {
    
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:targetDate].day;
}

#pragma mark 获取目标 NSDate 星期
/// 获取目标 NSDate 星期
/// @param targetDate 目标时间
+ (NSString *)getTargetDateWeek:(NSDate *)targetDate {
    
    NSInteger weekday = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday fromDate:targetDate].weekday;
    return [FWDateWeekDays objectAtIndex:weekday];
}

#pragma mark 获取目标 NSDate 小时
/// 获取目标 NSDate 小时
/// @param targetDate 目标时间
+ (NSInteger)getTargetDateHour:(NSDate *)targetDate {
    
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:targetDate].hour;
}

#pragma mark 获取目标 NSDate 分钟
/// 获取目标 NSDate 分钟
/// @param targetDate 目标时间
+ (NSInteger)getTargetDateMinute:(NSDate *)targetDate {
    
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:targetDate].minute;
}

#pragma mark 获取目标 NSDate 秒数
/// 获取目标 NSDate 秒数
/// @param targetDate 目标时间
+ (NSInteger)getTargetDateSeconds:(NSDate *)targetDate {
    
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:targetDate].second;
}

#pragma mark 获取某年某月的天数
/// 获取某年某月的天数
/// @param year 目标年份
/// @param month 目标月份
+ (NSInteger)getDayInThisYear:(NSInteger)year withMonth:(NSInteger)month {
    
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12)) {
        /// 固定为31天
        return 31;
    } else if ((month == 4) || (month == 6) || (month == 9) || (month == 11)) {
        /// 固定为30天
        return 30;
    } else {
        if ((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3)) {
            return 28;
        } else if (year % 400 == 0) {
            return 29;
        } else if (year % 100 == 0) {
            return 28;
        } else {
            return 29;
        }
    }
}

#pragma mark - 计算某个时间距离今天的时间
/// 计算某个时间距离今天的时间
/// @param timeStamp 时间戳
+ (NSString *)rangeTimeStampString:(NSInteger)timeStamp {
    
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    
    NSDate *newDateFormatter = [dateFormatter dateFromString:[FWDateBridge timeStampConversionNSString:timeStamp format:format]];

    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *current_date = [[NSDate alloc] init];
    
    NSTimeInterval time = [current_date timeIntervalSinceDate:newDateFormatter];
    
    int month = ((int)time)/(3600*24*30);
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/60;
    int second = ((int)time)%(3600*24*60*60);
    NSString *timeStr;
    if(month != 0) {
        timeStr = [NSString stringWithFormat:@"%i%@", month, NSLocalizedString(@"个月前", nil)];
    } else if(days != 0) {
        timeStr = [NSString stringWithFormat:@"%i%@", days, NSLocalizedString(@"天前", nil)];
    } else if(hours != 0) {
        timeStr = [NSString stringWithFormat:@"%i%@", hours, NSLocalizedString(@"小时前", nil)];
    } else if(minute != 0) {
        timeStr = [NSString stringWithFormat:@"%i%@", minute, NSLocalizedString(@"分钟前", nil)];
    } else {
        if (second <= 20) {
            timeStr = NSLocalizedString(@"刚刚", nil);
        } else {
            timeStr = [NSString stringWithFormat:@"%i%@", second, NSLocalizedString(@"秒前", nil)];
        }
    }
    return timeStr;
}

@end
