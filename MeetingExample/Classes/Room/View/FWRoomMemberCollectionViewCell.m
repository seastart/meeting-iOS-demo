//
//  FWRoomMemberCollectionViewCell.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/2.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWRoomMemberCollectionViewCell.h"
#import "FWRoomMemberModel.h"
#import "FWRoomStatusView.h"

@interface FWRoomMemberCollectionViewCell()

/// 播放器窗口
@property (weak, nonatomic) IBOutlet UIView *playerView;
/// 成员状态组件
@property (weak, nonatomic) IBOutlet FWRoomStatusView *statusView;

@end

@implementation FWRoomMemberCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    /// 配置属性
    [self stepConfig];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        /// 加载CollectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FWRoomMemberCollectionViewCell" owner:self options:nil];
        /// 如果路径不存在
        if (arrayOfViews.count < 1) {
            return nil;
        }
        /// 如果xib中view不属于UICollectionViewCell类
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        /// 加载Cell
        self = [arrayOfViews firstObject];
        /// 配置属性
        [self stepConfig];
    }
    return self;
}

#pragma mark - 配置属性
/// 配置属性
- (void)stepConfig {
    
    /// 设置背景色
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - 设置成员信息
/// 设置成员信息
/// @param memberModel 成员信息
- (void)setMemberModel:(nullable FWRoomMemberModel *)memberModel {
    
    /// 如果当前订阅了该成员
//    if (memberModel.subscribe) {
//        /// 获取成员详细信息
//        RTCEngineUserModel *userModel = [[FWEngineBridge sharedManager] findMemberWithUserId:memberModel.uid];
//        /// 声明目标流是否存在
//        BOOL isExist = NO;
//        /// 查找当前订阅的视频流
//        for (RTCEngineStreamModel *streamModel in userModel.streams) {
//            /// 查找对应码流
//            if (streamModel.id == memberModel.trackIdentifier) {
//                /// 设置标记该流存在
//                isExist = YES;
//                break;
//            }
//        }
//        /// 如果订阅了该轨道，但是该轨道已经不在推流
//        if (!isExist) {
//            /// 标记未订阅
//            memberModel.subscribe = NO;
//            /// 重新订阅轨道
//            [self reloadSubscribe];
//        }
//    }
    /// 缓存成员信息
    _memberModel = memberModel;
    /// 设置显示内容
    [self.statusView setupMemberInfoWithUserModel:memberModel];
}

#pragma mark - 重新订阅轨道
/// 重新订阅轨道
- (void)reloadSubscribe {
    
//    if (_memberModel.subscribe) {
//        /// 订阅远端用户的视频流
//        [[FWEngineBridge sharedManager] startRemoteView:_memberModel.uid trackId:_memberModel.trackIdentifier view:self.playerView];
//    } else {
//        /// 停止订阅远端用户的视频流
//        [[FWEngineBridge sharedManager] stopRemoteView:_memberModel.uid trackId:_memberModel.trackIdentifier];
//    }
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
