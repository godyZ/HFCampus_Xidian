//
//  NewsViewController.h
//  HFCampus
//
//  Created by zhangrongjian on 13-12-26.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "ViewPagerController.h"
#import <QuartzCore/QuartzCore.h>

@interface NewsViewController : ViewPagerController

@property (strong, readonly, nonatomic) RESideMenu *sideMenu;  //左侧划栏

@end
