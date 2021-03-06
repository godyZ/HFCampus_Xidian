//
//  newsContentTableViewController.h
//  HFCampus
//
//  Created by zhangrongjian on 13-12-26.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsViewController.h"
@interface newsContentTableViewController : UITableViewController

@property (nonatomic, copy) NSString *newsType; //标实是什么类型新闻，并且填充url
@property (nonatomic, assign) BOOL isNoMore;
@property (nonatomic, strong) UINavigationController *originalNavigationController;
@property (nonatomic, strong) NewsViewController * bigNewsViewController;


@end
