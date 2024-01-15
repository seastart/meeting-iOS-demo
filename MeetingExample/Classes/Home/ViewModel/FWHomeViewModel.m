//
//  FWHomeViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWHomeViewModel.h"

@interface FWHomeViewModel()

@end

@implementation FWHomeViewModel

/// 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _toastSubject = [RACSubject subject];
        _loading = NO;
    }
    return self;
}

@end
