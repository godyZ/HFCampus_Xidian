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
@property (strong, nonatomic) UINavigationController *globalNewsNavigationController;
@property (strong, nonatomic) UINavigationController *globalPersonsNavigationController;

+ (NSInteger)OSVersion;
@end
