//
//  FWHomeTableViewCell.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/15.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWHomeTableViewCell.h"

/// 定义重用标识
static NSString *FWHomeTableViewCellName = @"FWHomeTableViewCell";

@interface FWHomeTableViewCell()

/// 缩略图
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
/// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// 描述
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

@end

@implementation FWHomeTableViewCell

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
    FWHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FWHomeTableViewCellName];
    /// 如果缓存池没有可重用的Cell，创建一个Cell，并给Cell绑定一个重用标识
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:FWHomeTableViewCellName owner:nil options:nil] lastObject];
    }
    return cell;
}

/// 设置项目内容
/// - Parameters:
///   - imageName: 图片
///   - titleText: 标题
///   - describeText:  描述
- (void)setupWithImageName:(NSString *)imageName titleText:(NSString *)titleText describeText:(NSString *)describeText {
    
    [self.thumbnailView setImage:kGetImage(imageName)];
    [self.titleLabel setText:titleText];
    [self.describeLabel setText:describeText];
}

@end
