//
//  AlgorithmNavigationController.m
//  HFCampus
//
//  Created by zhangrongjian on 14-2-14.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import "AlgorithmNavigationController.h"

@interface AlgorithmNavigationController ()

@end

@implementation AlgorithmNavigationController

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
