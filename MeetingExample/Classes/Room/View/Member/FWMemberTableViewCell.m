//
//  FWMemberTableViewCell.m
//  MeetingExample
//
//  Created by SailorGa on 2024/2/4.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMemberTableViewCell.h"

/// 定义重用标识
static NSString *FWMemberTableViewCellName = @"FWMemberTableViewCell";

@interface FWMemberTableViewCell()

/// 头像视图
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/// 昵称标签
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
/// 昵称标签
@property (weak, nonatomic) IBOutlet UILabel *centreNicknameLabel;
/// 角色标签
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
/// 音频状态按钮
@property (weak, nonatomic) IBOutlet UIButton *audioButton;
/// 视频状态按钮
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
/// 移除成员按钮
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
/// 视频状态按钮右边距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoRightMarginH;

/// 成员麦克风事件回调
@property (copy, nonatomic) FWMemberTableViewCellMicrophoneBlock microphoneBlock;
/// 成员摄像头事件回调
@property (copy, nonatomic) FWMemberTableViewCellCameraBlock cameraBlock;
/// 成员移除事件回调
@property (copy, nonatomic) FWMemberTableViewCellRemoveBlock removeBlock;
/// 成员标识
@property (copy, nonatomic) NSString *userId;
/// 成员昵称
@property (copy, nonatomic) NSString *nickname;
/// 成员索引
@property (assign, nonatomic) NSInteger index;

@end

@implementation FWMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    /// Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    /// Configure the view for the selected state
}

/// 创建Table View Cell
/// - Parameter tableView: Table View
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    /// 先去缓存池找可重用的Cell
    FWMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FWMemberTableViewCellName];
    /// 如果缓存池没有可重用的Cell，创建一个Cell，并给Cell绑定一个重用标识
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:FWMemberTableViewCellName owner:nil options:nil] lastObject];
        /// 配置属性
        [cell stepConfig];
    }
    return cell;
}

#pragma mark - 配置属性
- (void)stepConfig {
    
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 绑定动态响应信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定音频状态按钮事件
    [[self.audioButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        if (self.microphoneBlock) {
            self.microphoneBlock(self.index);
        }
    }];
    
    /// 绑定视频状态按钮事件
    [[self.videoButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        if (self.cameraBlock) {
            self.cameraBlock(self.index);
        }
    }];
    
    /// 绑定移除成员按钮事件
    [[self.removeButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        if (self.removeBlock) {
            self.removeBlock(self.userId, self.nickname);
        }
    }];
}

#pragma mark - 设置项目内容
/// 设置项目内容
/// - Parameters:
///   - userId: 用户标识
///   - avatarUrl: 头像地址
///   - nicknameText: 昵称
///   - isOwner: 是否是主持人
///   - oneself: 是否是自己
///   - videoState: 视频状态
///   - audioState: 音频状态
///   - index: 成员索引
///   - microphoneBlock: 成员麦克风事件回调
///   - cameraBlock: 成员摄像头事件回调
///   - removeBlock: 成员移除事件回调
- (void)setupWithUserId:(NSString *)userId avatarUrl:(NSString *)avatarUrl nicknameText:(NSString *)nicknameText isOwner:(BOOL)isOwner oneself:(BOOL)oneself videoState:(BOOL)videoState audioState:(BOOL)audioState index:(NSInteger)index microphoneBlock:(FWMemberTableViewCellMicrophoneBlock)microphoneBlock cameraBlock:(FWMemberTableViewCellCameraBlock)cameraBlock removeBlock:(FWMemberTableViewCellRemoveBlock)removeBlock {
    
    /// 保存麦克风事件回调
    self.microphoneBlock = microphoneBlock;
    /// 保存摄像头事件回调
    self.cameraBlock = cameraBlock;
    /// 保存移除事件回调
    self.removeBlock = removeBlock;
    /// 保存成员昵称
    self.nickname = nicknameText;
    /// 保存成员标识
    self.userId = userId;
    /// 保存成员索引
    self.index = index;
    
    /// 设置头像
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[avatarUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:kGetImage(FWDEFAULTAVATAR)];
    /// 设置昵称
    [self.nicknameLabel setText:nicknameText];
    [self.centreNicknameLabel setText:nicknameText];
    
    /// 声明角色显示
    NSString *positionText = @"";
    if (isOwner) {
        /// 主持人角色
        if (oneself) {
            positionText = @"(我，主持人)";
        } else {
            positionText = @"(主持人)";
        }
    } else {
        /// 非主持人角色
        if (oneself) {
            positionText = @"(我)";
        } else {
            positionText = @"";
        }
    }
    /// 角色标签
    [self.positionLabel setText:positionText];
    
    /// 设置音视频按钮状态
    self.videoButton.selected = !videoState;
    self.audioButton.selected = !audioState;
    
    /// 设置部分视图显示状态
    if (!isOwner && !oneself) {
        self.positionLabel.hidden = YES;
        self.nicknameLabel.hidden = YES;
        self.centreNicknameLabel.hidden = NO;
    } else {
        self.positionLabel.hidden = NO;
        self.nicknameLabel.hidden = NO;
        self.centreNicknameLabel.hidden = YES;
    }
    
    if (!oneself && !isOwner) {
        /// 该成员是自己且当前登录成员为主持人
        self.removeButton.hidden = NO;
        /// 设置视频状态按钮右边距
        self.videoRightMarginH.constant = 51.0;
    } else {
        /// 该成员非自己且当前登录成员非主持人
        self.removeButton.hidden = YES;
        /// 设置视频状态按钮右边距
        self.videoRightMarginH.constant = 16.0;
    }
}

@end
