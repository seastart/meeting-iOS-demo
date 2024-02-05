//
//  FWMemberViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/2/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMemberViewModel.h"

@implementation FWMemberViewModel

#pragma mark - 初始化ViewModel
/// 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _toastSubject = [RACSubject subject];
        _frequencyAllEnabled = NO;
        _framesAllEnabled = NO;
        _loading = NO;
    }
    return self;
}

@end
