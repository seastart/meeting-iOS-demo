//
//  FWRoomViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/2.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWRoomViewModel.h"

@interface FWRoomViewModel()

@end

@implementation FWRoomViewModel

#pragma mark - 初始化方法
/// 初始化方法
- (instancetype)initWithRoomNo:(NSString * _Nonnull)roomNo {
    
    if (self = [super init]) {
        _loading = NO;
        _roomText = roomNo;
        _toastSubject = [RACSubject subject];
    }
    return self;
}

@end
