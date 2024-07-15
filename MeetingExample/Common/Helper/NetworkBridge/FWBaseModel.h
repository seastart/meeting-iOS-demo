//
//  FWBaseModel.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/7.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWBaseModel : NSObject

/// 错误码
@property (nonatomic, assign) NSInteger code;
/// 错误描述
@property (nonatomic, copy) NSString *msg;

@end

NS_ASSUME_NONNULL_END
