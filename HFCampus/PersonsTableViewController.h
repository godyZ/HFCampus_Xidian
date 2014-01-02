//
//  PersonsTableViewController.h
//  HFCampus
//
//  Created by zhangrongjian on 13-12-26.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface PersonsTableViewController : UITableViewController

@property (strong, nonatomic) RESideMenu * sideMenu;
@property (weak, nonatomic) IBOutlet UIImageView *personThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UILabel *personQuotation;
@property (weak, nonatomic) IBOutlet UILabel *period;

@end
