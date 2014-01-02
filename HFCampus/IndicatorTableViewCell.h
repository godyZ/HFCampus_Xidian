//
//  IndicatorTableViewCell.h
//  HFCampus
//
//  Created by zhangrongjian on 13-12-28.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndicatorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *loadMoreLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadMoreIndicator;

@end
