//
//  IndicatorTableViewCell.m
//  HFCampus
//
//  Created by zhangrongjian on 13-12-28.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#import "IndicatorTableViewCell.h"

@implementation IndicatorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
