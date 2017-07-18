//
//  TableViewCell.m
//  Demo
//
//  Created by maygolf on 2017/7/18.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "Masonry.h"
#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.numberOfLines = 0;
        self.label = label;
        
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 20, 5, 20));
        }];
    }
    return self;
}

@end
