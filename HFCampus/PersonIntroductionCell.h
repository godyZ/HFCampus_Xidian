//
//  PersonIntroductionCell.h
//  HFCampus
//
//  Created by zhangrongjian on 14-1-5.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonIntroductionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIWebView *webViewContent;

@end
