//
//  FWMessageMineTableViewCell.m
//  MeetingExample
//
//  Created by SailorGa on 2023/2/28.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWMessageMineTableViewCell.h"

/// 定义一个重用标识
static NSString *FWMessageMineTableViewCellIdentifier = @"FWMessageMineTableViewCell";

@interface FWMessageMineTableViewCell()

/// 成员头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/// 成员昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/// 消息内容
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation FWMessageMineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    /// Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    /// Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    /// 先去缓存池找可重用的cell
    FWMessageMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FWMessageMineTableViewCellIdentifier];
    /// 如果缓存池没有可重用的cell,创建一个cell,并给cell绑定一个重用标识
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:FWMessageMineTableViewCellIdentifier owner:nil options:nil] lastObject];
    }
    return cell;
}

#pragma mark - 设置显示内容
/// 设置显示内容
/// - Parameters:
///   - nameText: 用户昵称
///   - messageText: 消息内容
///   - avatarUrl: 头像地址
- (void)setupConfig:(NSString *)nameText messageText:(NSString *)messageText avatarUrl:(nullable NSString *)avatarUrl {
    
    self.nameLabel.text = nameText;
    self.messageLabel.text = messageText;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[avatarUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:kGetImage(@"icon_common_avatar")];
}

@end
