//
//  AppDelegate.h
//  HFCampus
//
//  Created by zhangrongjian on 13-12-26.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../RESTfulEngine/RESTfulEngine.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RESTfulEngine *restfulEngine;
@property (strong, nonatomic) UINavigationController *globalNewsNavigationController;       //咨询
@property (strong, nonatomic) UINavigationController *globalPersonsNavigationController;    //人物
@property (strong, nonatomic) UINavigationController *globalTopicNavigationController;      //话题
@property (strong, nonatomic) UINavigationController *globalAlgorithmNavigationController;  //算法


//****工具*****
@property (strong, nonatomic) UINavigationController *globalPhoneSearchNavigationController;
@property (strong, nonatomic) UINavigationController *globalBooksSearchNavigationController;
@property (strong, nonatomic) UINavigationController *globalExpressSearchNavigationController;

+ (NSInteger)OSVersion;
@end
