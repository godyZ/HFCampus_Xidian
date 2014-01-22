//
//  BookContentViewController.h
//  HFCampus
//
//  Created by zhangrongjian on 14-1-21.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookContentViewController : UIViewController

@property (retain, nonatomic) NSString *htmlStr;

@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end
