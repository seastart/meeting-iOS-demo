//
//  FWAuthToken.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/7.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWAuthToken : FWBaseModel

/// 鉴权令牌
@property (nonatomic, copy) NSString *data;

@end

NS_ASSUME_NONNULL_END
