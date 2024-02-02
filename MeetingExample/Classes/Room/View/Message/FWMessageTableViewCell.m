//
//  FWMessageTableViewCell.m
//  MeetingExample
//
//  Created by SailorGa on 2024/2/2.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMessageTableViewCell.h"

/// 定义一个重用标识
static NSString *FWMessageTableViewCellIdentifier = @"FWMessageTableViewCell";

@interface FWMessageTableViewCell()

/// 成员头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/// 成员昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/// 消息内容
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation FWMessageTableViewCell

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
    FWMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FWMessageTableViewCellIdentifier];
    /// 如果缓存池没有可重用的cell,创建一个cell,并给cell绑定一个重用标识
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:FWMessageTableViewCellIdentifier owner:nil options:nil] lastObject];
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
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[avatarUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:kGetImage(@"icon_login_avatar1")];
}

@end
