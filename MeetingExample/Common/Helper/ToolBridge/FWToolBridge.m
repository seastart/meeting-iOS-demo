//
//  FWToolBridge.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/7.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWToolBridge.h"

@implementation FWToolBridge

#pragma mark - 获取应用程序签名环境
/// 获取应用程序签名环境
+ (FWCertificateState)getApplicationCertificate {
    
    /// 默认签名环境
    FWCertificateState state = FWCertificateStateAppStore;
    /// 取出embedded.mobileprovision这个描述文件的内容进行判断
    NSString *mobileProvisionPath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    NSData *rawData = [NSData dataWithContentsOfFile:mobileProvisionPath];
    if (!rawData) {
        /// AppStore版本
        state = FWCertificateStateAppStore;
    }
    NSString *rawDataString = [[NSString alloc] initWithData:rawData encoding:NSASCIIStringEncoding];
    NSRange plistStartRange = [rawDataString rangeOfString:@"<plist"];
    NSRange plistEndRange = [rawDataString rangeOfString:@"</plist>"];
    if (plistStartRange.location != NSNotFound && plistEndRange.location != NSNotFound) {
        NSString *tempPlistString = [rawDataString substringWithRange:NSMakeRange(plistStartRange.location, NSMaxRange(plistEndRange))];
        NSData *tempPlistData = [tempPlistString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *plistDic =  [NSPropertyListSerialization propertyListWithData:tempPlistData options:NSPropertyListImmutable format:nil error:nil];
        /// 签名证书名称
        NSString *certificateName = [plistDic valueForKey:@"Name"];
        if ([certificateName containsString:@"dev"]) {
            /// Debug版本
            state = FWCertificateStateDebug;
        } else if ([certificateName containsString:@"adhoc"]) {
            /// Adhoc版本
            state = FWCertificateStateAdhoc;
        } else {
            /// AppStore版本
            state = FWCertificateStateAppStore;
        }
    }
    return state;
}

#pragma mark - 获取UUID随机标识字符串
/// 获取UUID随机标识字符串
+ (NSString *)getUniqueIdentifier {
    
    /// 生成UUID并替换UUID分段连接符以及转换成小写
    return [[[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}

#pragma mark - 获取设备唯一标识符
/// 获取设备唯一标识符
+ (NSString *)getIdentifierForVendor {
    
    /// 获取设备标识并替换分段连接符以及转换成小写
    return [[[UIDevice currentDevice].identifierForVendor UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

#pragma mark - 获取设备名称
/// 获取设备名称
+ (NSString *)getDeviceName {
    
    return [UIDevice currentDevice].name;
}

#pragma mark - 房间号码转换字符串
/// 房间号码转换字符串
/// - Parameter roomno: 房间号码
+ (NSString *)roomnoDiversionString:(NSString *)roomno {
    
    NSUInteger chunkSize = 3;
    NSMutableArray<NSString *> *resultArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < roomno.length; i += chunkSize) {
        NSRange range = NSMakeRange(i, MIN(chunkSize, roomno.length - i));
        NSString *substring = [roomno substringWithRange:range];
        [resultArray addObject:substring];
    }
    /// 数组拼接成字符串
    NSString *roomnoStr = [resultArray componentsJoinedByString:@" "];
    /// 返回房间号码
    return roomnoStr;
}

#pragma mark - 字符串转换房间号码
/// 字符串转换房间号码
/// - Parameter string: 目标字符串
+ (NSString *)stringDiversionRoomno:(NSString *)string {
    
    /// 替换显示字符串中的空格字符
    NSString *roomno = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    /// 返回房间号码
    return roomno;
}

#pragma mark - 移除字符串两侧空格
/// 移除字符串两侧空格
/// - Parameter text: 原始串
+ (nullable NSString *)clearMarginsBlank:(nullable NSString *)text {
    
    /// 移除字符串两侧空格
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark - 验证房间号码是否有效
/// 验证房间号码是否有效
/// - Parameter roomNo: 房间号码
+ (BOOL)isValidateRoomNo:(NSString *)roomNo {
    
    if (roomNo.length > 64) {
        return NO;
    }
    
    /**
     * 标识通话的房间号码，长度在64字节以内的字符串。以下为支持的字符集范围(共89个字符)
     * 26个小写字母 a-z
     * 26个大写字母 A-Z
     * 10个数字 0-9
     * 空格
     * "!" "%" "&" "(" ")" "+" "-" ";"
     * "<" ">" "=" "." "?" "@" "[" "]"
     * "{" "}" "|" "~" ","
     */
    NSString *ROOMNO = @"^[A-Za-z0-9 _!%&()+\\-;<>=.?@\\[\\]{}|~,]+$";
    
    NSPredicate *regextestroom = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ROOMNO];
    
    if ([regextestroom evaluateWithObject:roomNo]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 请求权限
/// 请求权限
/// @param state 权限类型
/// @param superVC 控制器
/// @param resultBlock 返回结果
+ (void)requestAuthorization:(FWPermissionsState)state superVC:(nullable UIViewController *)superVC result:(nullable FWPermissionsResultBlock)resultBlock {
    
    switch (state) {
        case FWPermissionsStateVideo: {
            if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])) {
                NSString *mediaType = AVMediaTypeVideo;
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                switch (authStatus) {
                    case AVAuthorizationStatusDenied:
                    case AVAuthorizationStatusRestricted: {
                        if (resultBlock) {
                            resultBlock(NO);
                        }
                        /// 提示相机授权
                        [self presentAuthorizationVideoWithSuperVC:superVC];
                    }
                        break;
                    case AVAuthorizationStatusNotDetermined: {
                        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (resultBlock) {
                                    resultBlock(granted);
                                }
                            });
                        }];
                    }
                        break;
                    case AVAuthorizationStatusAuthorized: {
                        if (resultBlock) {
                            resultBlock(YES);
                        }
                    }
                        break;
                }
            }
        }
            break;
        case FWPermissionsStateAudio: {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
            switch (authStatus) {
                case AVAuthorizationStatusNotDetermined: {
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (resultBlock) {
                                resultBlock(granted);
                            }
                        });
                    }];
                }
                    break;
                case AVAuthorizationStatusRestricted:
                case AVAuthorizationStatusDenied:
                    if (resultBlock) {
                        resultBlock(NO);
                    }
                    /// 提示麦克风授权
                    [self presentAuthorizationAudioWithSuperVC:superVC];
                    break;
                case AVAuthorizationStatusAuthorized:
                    if (resultBlock) {
                        resultBlock(YES);
                    }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 提示相机授权
/// 提示相机授权
/// @param superVC 控制器
+ (void)presentAuthorizationVideoWithSuperVC:(nullable UIViewController *)superVC {
    
    if (!superVC) {
        /// 控制器为空时，丢弃该指令
        return;
    }
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"请在设备的“设置-隐私-相机”中允许%@访问您的相机", nil), BundleDisplayName];
    [self presentAuthorizationAlertWithTitle:NSLocalizedString(@"无法使用相机", nil) message:message superVC:superVC];
}

#pragma mark - 提示麦克风授权
/// 提示麦克风授权
/// @param superVC 控制器
+ (void)presentAuthorizationAudioWithSuperVC:(nullable UIViewController *)superVC {
    
    if (!superVC) {
        /// 控制器为空时，丢弃该指令
        return;
    }
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"请在设备的“设置-隐私-麦克风”中允许%@访问您的麦克风", nil), BundleDisplayName];
    [self presentAuthorizationAlertWithTitle:NSLocalizedString(@"无法使用麦克风", nil) message:message superVC:superVC];
}

#pragma mark - 授权情况提示
/// 授权情况提示
/// @param title 标题
/// @param message 详情
/// @param superVC 控制器
+ (void)presentAuthorizationAlertWithTitle:(NSString *)title message:(NSString *)message superVC:(UIViewController *)superVC {
    
    /// 弹出提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"前往设置", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        /// 跳转设置页面
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                /// 埋点日志
                SGLOG(@"授权提示，前往设置 %@", success ? @"成功" : @"失败");
            }];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    /// 加载到视图
    [superVC presentViewController:alert animated:YES completion:nil];
}

@end
