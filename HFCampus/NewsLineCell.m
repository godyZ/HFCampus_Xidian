//
//  NewsLineCell.m
//  HFCampus
//
//  Created by zhangrongjian on 13-12-27.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#import "NewsLineCell.h"

@implementation NewsLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.newsThumbnailImage.layer.cornerRadius = 20.0f;
        self.newsThumbnailImage.layer.masksToBounds = YES;
        
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
