//
//  SearchBookNavigationController.m
//  HFCampus
//
//  Created by zhangrongjian on 14-2-14.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import "SearchBookNavigationController.h"

@interface SearchBookNavigationController ()

@end

@implementation SearchBookNavigationController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
