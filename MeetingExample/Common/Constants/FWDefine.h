//
//  FWDefine.h
//  MeetingExample
//
//  Created by SailorGa on 2024/7/5.
//  Copyright © 2024 SailorGa. All rights reserved.
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


#pragma mark - 网页加载类型
/**
 网页加载类型

 - FWAccountWebTypeAssert: 免责声明
 - FWAccountWebTypePersonal: 个人信息收集清单
 - FWAccountWebTypeThirdParty: 第三方信息共享清单
 - FWAccountWebTypeAgreement: 用户协议
 - FWAccountWebTypePrivacy: 隐私协议
*/
typedef enum : NSUInteger {
    FWAccountWebTypeAssert,
    FWAccountWebTypePersonal,
    FWAccountWebTypeThirdParty,
    FWAccountWebTypeAgreement,
    FWAccountWebTypePrivacy
} FWAccountWebType;


NS_ASSUME_NONNULL_END
