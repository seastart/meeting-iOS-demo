//
//  FWUserExtendModel.h
//  MeetingExample
//
//  Created by SailorGa on 2023/2/27.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWUserExtendModel : NSObject

/// 视频状态
@property (nonatomic, assign) BOOL videoState;
/// 音频状态
@property (nonatomic, assign) BOOL audioState;

@end

NS_ASSUME_NONNULL_END
