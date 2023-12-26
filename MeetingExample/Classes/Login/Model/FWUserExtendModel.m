//
//  FWUserExtendModel.m
//  MeetingExample
//
//  Created by SailorGa on 2023/2/27.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWUserExtendModel.h"

@implementation FWUserExtendModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _videoState = NO;
        _audioState = NO;
    }
    return self;
}

@end
