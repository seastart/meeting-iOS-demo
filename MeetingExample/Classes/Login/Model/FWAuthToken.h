//
//  FWAuthToken.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/7.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FWAuthTokenItem;

@interface FWAuthToken : FWBaseModel

/// 签名对象
@property (nonatomic, strong) FWAuthTokenItem *data;

@end

@interface FWAuthTokenItem : NSObject

/// 鉴权令牌
@property (nonatomic, copy) NSString *token;

@end

NS_ASSUME_NONNULL_END
