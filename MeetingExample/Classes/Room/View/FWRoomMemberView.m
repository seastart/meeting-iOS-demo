//
//  FWRoomMemberView.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/2.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWRoomMemberView.h"
#import "FWRoomMemberModel.h"
#import "FWRoomMemberCollectionViewCell.h"

#define FW_COLLECTION_SECTION_INSET 0.f
#define FW_COLLECTION_CELL_SPACE 5.f
#define FW_COLLECTION_CELL_WIDTH (self.frame.size.width - FW_COLLECTION_CELL_SPACE * 1) / 2.f
#define FW_COLLECTION_CELL_HEIGHT FW_COLLECTION_CELL_WIDTH * 16 / 9.f

/// 定义CollectionViewCell重用标识
static NSString *FWRoomMemberCollectionViewCellName = @"FWRoomMemberCollectionViewCell";

@interface FWRoomMemberView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// 房间内成员视图单元格列表，用于渲染收到的视频流
@property (nonatomic, strong) NSMutableArray<FWRoomMemberCollectionViewCell *> *displayCells;
/// 房间内成员列表
@property (nonatomic, strong) NSMutableArray<FWRoomMemberModel *> *roomDataArray;

@end

@implementation FWRoomMemberView

#pragma mark - 初始化方法
/// 初始化方法
/// @param frame 布局
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        /// 配置属性
        [self setupConfig];
    }
    return self;
}

#pragma mark - Xib加载初始化
/// Xib加载初始化
- (void)awakeFromNib {
    
    [super awakeFromNib];
    /// 配置属性
    [self setupConfig];
}

#pragma mark - 懒加载房间内成员
- (NSMutableArray <FWRoomMemberModel *> *)roomDataArray {
    
    if (!_roomDataArray) {
        _roomDataArray = [NSMutableArray array];
    }
    return _roomDataArray;
}

#pragma mark - 懒加载成员视图列表
- (NSMutableArray <FWRoomMemberCollectionViewCell *> *)displayCells {
    
    if (!_displayCells) {
        _displayCells = [NSMutableArray array];
    }
    return _displayCells;
}

#pragma mark - 配置属性
/// 配置UI属性
- (void)setupConfig {
    
    /// 设置背景颜色
    self.backgroundColor = [UIColor clearColor];
    /// 设置列表代理
    self.delegate = self;
    /// 设置数据源代理
    self.dataSource = self;
    /// 注册CollectionViewCell
    /// [self registerNib:[UINib nibWithNibName:@"FWRoomMemberCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:FWRoomMemberCollectionViewCellName];
    /// 设置列表占位图
    [self setupEmptyViewWithImage:kGetImage(@"icon_common_empty") titleStr:NSLocalizedString(@"房间暂无成员~", nil) detailStr:nil];
}

#pragma mark - 成员更新信息
/// 成员更新信息
/// @param userId 成员ID
- (void)memberUpdateWithUserId:(NSString *)userId {
    
    /// 默认此成员不存在
    __block FWRoomMemberModel *memberModel = nil;
    /// 遍历成员列表，检测是否存在该成员
    [self.roomDataArray enumerateObjectsUsingBlock:^(FWRoomMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.uid isEqualToString:userId]) {
            /// 检测已经存在该成员
            memberModel = obj;
            *stop = YES;
        }
    }];
    
    /// 不存在该成员
    if (!memberModel) {
        /// 构造成员信息
        FWRoomMemberModel *model = [[FWRoomMemberModel alloc] init];
        model.uid = userId;
        /// 执行列表批量更新
        [self performBatchUpdates:^{
            /// 添加进成员列表
            [self.roomDataArray addObject:model];
            /// 获取成员在列表中的索引
            NSUInteger row = [self.roomDataArray indexOfObject:model];
            /// 在索引路径处插入项目
            [self insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]];
        } completion:^(BOOL finished) {
            /// 刷新列表
            /// [self.collectionView reloadData];
        }];
    } else {
        /// 检测已经存在该成员(替换成员信息)
        /// 更新成员视图单元格中关联的成员信息
        [self displayCellsUpdateModel:memberModel subscribe:NO];
    }
    
    /// 设置展位图显示转态
    [self setupEmptyViewHidden];
}

#pragma mark - 成员离开房间
/// 成员离开房间
/// @param userId 成员ID
- (void)memberExitWithUserId:(NSString *)userId {
    
    /// 默认此成员不存在
    __block FWRoomMemberModel *memberModel = nil;
    /// 遍历成员列表，检测是否存在该成员
    [self.roomDataArray enumerateObjectsUsingBlock:^(FWRoomMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.uid isEqualToString:userId]) {
            /// 检测已经存在该成员
            memberModel = obj;
            *stop = YES;
        }
    }];
    
    /// 存在该成员
    if (memberModel) {
        /// 获取成员在列表中的索引
        NSUInteger row = [self.roomDataArray indexOfObject:memberModel];
        [self performBatchUpdates:^{
            /// 移除该成员
            [self.roomDataArray removeObject:memberModel];
            /// 移除索引路径中的项目
            [self deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]];
        } completion:^(BOOL finished) {
            /// 刷新列表
            /// [self.collectionView reloadData];
        }];
    }
    
    /// 设置展位图显示转态
    [self setupEmptyViewHidden];
}

#pragma mark - 更新成员视图中关联的成员信息
/// 更新成员视图中关联的成员信息
/// @param memberModel 成员信息
/// @param subscribe 是否需要订阅操作
- (void)displayCellsUpdateModel:(FWRoomMemberModel *)memberModel subscribe:(BOOL)subscribe {
    
    if (!memberModel) {
        return;
    }
    /// 查找对应的成员窗口
    [self.displayCells enumerateObjectsUsingBlock:^(FWRoomMemberCollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.memberModel.uid isEqualToString:memberModel.uid]) {
            /// 1、重新关联成员信息
            obj.memberModel = memberModel;
            /// 2、如果需要重新订阅轨道
            if (subscribe) {
                /// 重新订阅轨道
                [obj reloadSubscribe];
            }
        }
    }];
}

#pragma mark - 订阅成员视频流
/// 订阅成员视频流
/// @param memberModel 成员信息
/// @param trackId 轨道标识
/// @param subscribe 订阅状态
//- (void)subscribeWithMemberModel:(FWRoomMemberModel *)memberModel trackId:(RTCTrackIdentifierFlags)trackId subscribe:(BOOL)subscribe {
//    
//    if (!memberModel) {
//        return;
//    }
//    /// 更新订阅状态
//    memberModel.subscribe = subscribe;
//    /// 更新订阅轨道
//    memberModel.trackIdentifier = trackId;
//    /// 更新成员视图单元格中关联的成员信息
//    [self displayCellsUpdateModel:memberModel subscribe:YES];
//}

#pragma mark - 设置展位图显示转态
/// 设置展位图显示转态
- (void)setupEmptyViewHidden {
    
    /// 获取成员列表状态
    BOOL hidden = kArrayIsEmpty(self.roomDataArray);
    /// 设置展位图显示转态
    hidden ? [self ly_showEmptyView] : [self ly_hideEmptyView];
}

#pragma mark - ----- CollectionView&UICollectionViewDataSource的代理方法 -----
#pragma mark 分组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

#pragma mark 每组Cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.roomDataArray.count;
}

#pragma mark 设置每个Cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(FW_COLLECTION_CELL_WIDTH, FW_COLLECTION_CELL_HEIGHT);
}

#pragma mark 设置内容边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(FW_COLLECTION_SECTION_INSET, FW_COLLECTION_SECTION_INSET, FW_COLLECTION_SECTION_INSET, FW_COLLECTION_SECTION_INSET);
}

#pragma mark 设置最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return FW_COLLECTION_CELL_SPACE;
}

#pragma mark 设置最小项间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return FW_COLLECTION_CELL_SPACE;
}

#pragma mark 初始化Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /// FWRoomMemberCollectionViewCell *rCell = [collectionView dequeueReusableCellWithReuseIdentifier:FWRoomMemberCollectionViewCellName forIndexPath:indexPath];
    /// 声明重用标识符
    NSString *identifier = [NSString stringWithFormat:@"%@%ld", FWRoomMemberCollectionViewCellName, indexPath.row];
    /// 注册CollectionViewCell
    [collectionView registerClass:[FWRoomMemberCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    /// 获取复用Cell
    FWRoomMemberCollectionViewCell *rCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return rCell;
}

#pragma mark 开始显示Cell
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FWRoomMemberCollectionViewCell *rCell = (FWRoomMemberCollectionViewCell *)cell;
    /// 获取成员信息
    FWRoomMemberModel *memberModel = [self.roomDataArray objectAtIndex:indexPath.row];
    /// 绑定成员信息
    rCell.memberModel = memberModel;
    /// 将Item添加到列表
    [self.displayCells addObject:rCell];
}

#pragma mark 结束显示Cell
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FWRoomMemberCollectionViewCell *rCell = (FWRoomMemberCollectionViewCell *)cell;
    /// 解绑成员信息
    rCell.memberModel = nil;
    /// 将Item移除列表
    [self.displayCells removeObject:rCell];
}

#pragma mark Cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /// 获取成员信息
    FWRoomMemberModel *memberModel = [self.roomDataArray objectAtIndex:indexPath.row];
    /// 回调上层选中项
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(memberView:didSelectItemAtIndexPath:memberModel:)]) {
        [self.mDelegate memberView:self didSelectItemAtIndexPath:indexPath memberModel:memberModel];
    }
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
