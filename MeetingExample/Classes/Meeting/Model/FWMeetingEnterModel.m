//
//  FWMeetingEnterModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/4/25.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMeetingEnterModel.h"

@implementation FWMeetingEnterModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _videoState = NO;
        _audioState = NO;
    }
    return self;
}

@end
