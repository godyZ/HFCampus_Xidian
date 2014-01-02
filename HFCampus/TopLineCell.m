//
//  TopLineCell.m
//  HFCampus
//
//  Created by zhangrongjian on 13-12-27.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#import "TopLineCell.h"

@implementation TopLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, 320, TopLineCellHeight)
                                                              ImageArray:[NSArray arrayWithObjects:@"1.jpg",@"2.jpg",@"3.jpg", nil]
                                                              TitleArray:[NSArray arrayWithObjects:@"HFCampus新闻类版面图",@"HFCampus新版为ios7量身打造",@"HFCampus新版加入话题功能，更嗨跟给力", nil]];
        scroller.delegate=self;
        [self addSubview:scroller];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, 320, TopLineCellHeight)
                                                              ImageArray:[NSArray arrayWithObjects:@"TopLineTestImage",@"TopLineTestImage2",@"TopLineTestImage3", nil]
                                                              TitleArray:[NSArray arrayWithObjects:@"HFCampus新版为ios7量身打造",@"HFCampus新闻类版面图",@"HFCampus新版加入话题功能，更嗨跟给力", nil]];
        scroller.delegate=self;
        [self addSubview:scroller];
    }
    return self;
}

-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    NSLog(@"index--%ld",index);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
