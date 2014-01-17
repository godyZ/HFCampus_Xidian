//
//  PhoneSearchViewController.h
//  HFCampus
//
//  Created by zhangrongjian on 14-1-17.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface PhoneSearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, readonly, nonatomic) RESideMenu *sideMenu;  //左侧划栏
@property (nonatomic, strong) NSArray  *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *phoneTableView;

- (IBAction)SchoolPhone:(id)sender;
- (IBAction)OtherPhoneTouch:(id)sender;


@end
