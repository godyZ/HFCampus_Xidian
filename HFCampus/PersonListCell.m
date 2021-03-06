//
//  PersonListCell.m
//  HFCampus
//
//  Created by zhangrongjian on 14-1-2.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import "PersonListCell.h"

@implementation PersonListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.personThumbnail.layer.cornerRadius = 20.0f;
        self.personThumbnail.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
