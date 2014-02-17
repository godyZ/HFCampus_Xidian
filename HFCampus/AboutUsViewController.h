//
//  AboutUsViewController.h
//  HFCampus
//
//  Created by zhangrongjian on 14-2-13.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTGlassScrollView.h"
#import "RESideMenu.h"

@interface AboutUsViewController : UIViewController<UIScrollViewAccessibilityDelegate>

@property (strong, readonly, nonatomic) RESideMenu *sideMenu;  //左侧划栏

@end
