//
//  FWUserModel.h
//  MeetingExample
//
//  Created by SailorGa on 2024/7/12.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FWUserDetailsModel;

@interface FWUserModel : FWBaseModel

/// 用户详情
@property (nonatomic, strong) FWUserDetailsModel *data;

@end

@interface FWUserDetailsModel : NSObject

/// 用户标识
@property (nonatomic, copy) NSString *userId;
/// 用户昵称
@property (nonatomic, copy) NSString *nickname;
/// 用户头像
@property (nonatomic, copy) NSString *avatar;
/// 手机号码
@property (nonatomic, copy) NSString *mobile;
/// 鉴权令牌
@property (nonatomic, copy) NSString *token;

@end

NS_ASSUME_NONNULL_END
