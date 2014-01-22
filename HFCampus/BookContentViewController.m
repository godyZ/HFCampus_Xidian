//
//  BookContentViewController.m
//  HFCampus
//
//  Created by zhangrongjian on 14-1-21.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import "BookContentViewController.h"

@interface BookContentViewController ()

@end

@implementation BookContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.webView loadHTMLString:_htmlStr baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
