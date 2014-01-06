//
//  PersonContentViewController.h
//  HFCampus
//
//  Created by zhangrongjian on 14-1-3.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMScrollingNavbarViewController.h"


@interface PersonContentViewController : AMScrollingNavbarViewController<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *personContentTableView;
@property (strong, nonatomic) UIImage *personLargeThumbnail;
@property (copy, nonatomic) NSString *personName;
@property (copy, nonatomic) NSString *personQuotation;
@property (copy, nonatomic) NSString *personPeriod;
@property (copy, nonatomic) NSString *detailPersonURL;
@property (copy, nonatomic) NSString *thumbnail2;
@property (copy, nonatomic) NSString *title;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@end
