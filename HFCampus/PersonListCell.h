//
//  PersonListCell.h
//  HFCampus
//
//  Created by zhangrongjian on 14-1-2.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UILabel *personQuotation;
@property (weak, nonatomic) IBOutlet UILabel *personPeriod;
@property (weak, nonatomic) IBOutlet UIImageView *personThumbnail;



@end
