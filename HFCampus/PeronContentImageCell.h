//
//  PeronContentImageCell.h
//  HFCampus
//
//  Created by zhangrongjian on 14-1-5.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeronContentImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *personLargerThumbnail;
@property (weak, nonatomic) IBOutlet UIImageView *PersonSmallThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UILabel *personQuotation;
@property (weak, nonatomic) IBOutlet UILabel *personPeriod;
@property (weak, nonatomic) IBOutlet UIView *infoBox;

@end
