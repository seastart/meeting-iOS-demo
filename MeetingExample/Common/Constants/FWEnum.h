//
//  FWEnum.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/13.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 签名证书类型
/**
 签名证书类型

 - FWCertificateStateDebug: Debug版本
 - FWCertificateStateAdhoc: Adhoc版本
 - FWCertificateStateAppStore: AppStore版本
*/
typedef enum : NSUInteger {
    FWCertificateStateDebug = 1,
    FWCertificateStateAdhoc,
    FWCertificateStateAppStore
} FWCertificateState;

#pragma mark - 首页功能类型
/**
 首页功能类型

 - FWHomeFunctionTypeMetting: 会议类型
*/
typedef enum : NSUInteger {
    FWHomeFunctionTypeMetting
} FWHomeFunctionType;

#pragma mark - 会议入口类型
/**
 会议入口类型

 - FWMeetingEntryTypeCreate: 创建房间
 - FWMeetingEntryTypeJoin: 加入房间
*/
typedef enum : NSUInteger {
    FWMeetingEntryTypeCreate,
    FWMeetingEntryTypeJoin
} FWMeetingEntryType;

@interface FWEnum : NSObject

@end

NS_ASSUME_NONNULL_END
