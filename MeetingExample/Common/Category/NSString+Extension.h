//
//  NSString+Extension.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/17.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(Extension)

#pragma mark - 检测消息内容是否有效
/// 检测消息内容是否有效
- (BOOL)isContentEffective;

#pragma mark - 处理用户昵称
/// 处理用户昵称
- (NSString *)nicknameSuitScanf;

#pragma mark - 检测字符串是否为纯数字
/// 检测字符串是否为纯数字
- (BOOL)deptNumInputShouldNumber;

#pragma mark - 移除结尾的子字符串
/// 移除结尾的子字符串
/// - Parameter subString: 子字符串
- (NSString *)removeLastSubString:(NSString *)subString;

@end

NS_ASSUME_NONNULL_END
