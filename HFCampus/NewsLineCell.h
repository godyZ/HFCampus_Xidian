//
//  NewsLineCell.h
//  HFCampus
//
//  Created by zhangrongjian on 13-12-27.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsThumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsDescription;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel2;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel3;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel4;
@property (weak, nonatomic) IBOutlet UILabel *newsGentie;



@end
