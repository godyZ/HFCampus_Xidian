//
//  IndicatorPersonCell.h
//  HFCampus
//
//  Created by zhangrongjian on 14-1-3.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndicatorPersonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *loadMoreLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadMoreIndicator;

@end
