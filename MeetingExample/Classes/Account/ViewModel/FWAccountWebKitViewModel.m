//
//  FWAccountWebKitViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWAccountWebKitViewModel.h"

@implementation FWAccountWebKitViewModel

#pragma mark - 初始化方法
/// 初始化方法
/// @param type 网页加载类型
- (instancetype)initWithType:(FWAccountWebType)type {
    
    if (self = [super init]) {
        /// 初始化参数变量
        [self initType:type];
    }
    return self;
}

#pragma mark - 初始化方法
/// 初始化方法
/// @param type 网页加载类型
- (void)initType:(FWAccountWebType)type {
    
    _loading = NO;
    _type = type;
}

@end
