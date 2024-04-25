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
- (instancetype)initWithMeetingEnterModel:(FWMeetingEnterModel *)enterModel {
    
    if (self = [super init]) {
        _loading = NO;
        _enterModel = enterModel;
        _toastSubject = [RACSubject subject];
    }
    return self;
}

@end
