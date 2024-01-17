//
//  FWAccountPrivacyTableViewCell.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWAccountPrivacyTableViewCell.h"

/// 定义重用标识
static NSString *FWAccountPrivacyTableViewCellName = @"FWAccountPrivacyTableViewCell";

@interface FWAccountPrivacyTableViewCell()

/// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FWAccountPrivacyTableViewCell

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
    FWAccountPrivacyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FWAccountPrivacyTableViewCellName];
    /// 如果缓存池没有可重用的Cell，创建一个Cell，并给Cell绑定一个重用标识
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:FWAccountPrivacyTableViewCellName owner:nil options:nil] lastObject];
    }
    return cell;
}

/// 设置项目内容
/// - Parameters:
///   - titleText: 标题
- (void)setupWithTitleText:(NSString *)titleText {
    
    [self.titleLabel setText:titleText];
}

@end
