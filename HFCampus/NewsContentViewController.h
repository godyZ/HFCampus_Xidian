//
//  NewsContentViewController.h
//  HFCampus
//
//  Created by zhangrongjian on 13-12-30.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AMScrollingNavbarViewController.h"

@interface NewsContentViewController : AMScrollingNavbarViewController<UINavigationControllerDelegate>

@property (strong, nonatomic) MenuItem *item;
@property (assign, nonatomic) int contentType;  //1.新闻 2.讲座
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (strong, nonatomic) NSString *path;
@property (retain, nonatomic) NSString *shareString;

@end
