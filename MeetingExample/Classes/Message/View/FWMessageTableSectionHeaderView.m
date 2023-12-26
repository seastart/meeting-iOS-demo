//
//  FWMessageTableSectionHeaderView.m
//  MeetingExample
//
//  Created by SailorGa on 2023/2/28.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWMessageTableSectionHeaderView.h"

@interface FWMessageTableSectionHeaderView()

/// 内容
@property (strong, nonatomic) UIView *contentSectionView;
/// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FWMessageTableSectionHeaderView

#pragma mark - 初始化视图
/// 初始化视图
- (instancetype)init {

    self = [super init];
    if (self) {
        /// 配置属性
        [self setupConfig];
    }
    return self;
}

#pragma mark - 初始化方法
/// 返回类表分组分组部头
/// @param frame View 位置大小
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSectionView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentSectionView.frame = self.bounds;
        [self addSubview:self.contentSectionView];
        /// 配置属性
        [self setupConfig];
    }
    return self;
}

#pragma mark - 初始化视图
/// 初始化视图
/// @param aDecoder 解码器
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentSectionView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        /// 配置属性
        [self setupConfig];
    }
    return self;
}

#pragma mark - 页面重新绘制
/// 页面重新绘制
- (void)layoutSubviews {
    
    [super layoutSubviews];
    /// 重置内容layout
    self.contentView.frame = self.bounds;
}

#pragma mark - 配置属性
- (void)setupConfig {
    
    /// 配置属性
}

#pragma mark - 设置显示标题
/// 设置显示标题
/// - Parameter titleText: 标题
- (void)setupTitleText:(NSString *)titleText {
    
    self.titleLabel.text = titleText;
}

#pragma mark - 释放资源
- (void)dealloc {
    
    /// 追加打印日志
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
