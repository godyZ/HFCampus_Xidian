//
//  AboutUsViewController.m
//  HFCampus
//
//  Created by zhangrongjian on 14-2-13.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AppDelegate.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
{
    BTGlassScrollView *_glassScrollView;
}

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
	
    //showing white status
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //preventing weird inset
    [self setAutomaticallyAdjustsScrollViewInsets: NO];
    
    //navigation bar work
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:CGSizeMake(1, 1)];
    [shadow setShadowColor:[UIColor blackColor]];
    [shadow setShadowBlurRadius:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSShadowAttributeName: shadow};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.title = @"关 于 我 们";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"general"] style:UIBarButtonItemStylePlain target:self action:@selector(showRightMenu)];
    
    //background
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *view = [self customView];
    
    _glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"aboutBackGround"] blurredImage:nil viewDistanceFromBottom:120 foregroundView:view];
    
    [self.view addSubview:_glassScrollView];
}

- (UIView *)customView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 705)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
    [label setText:[NSString stringWithFormat:@" 嗨翻团队 ^_^"]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:40]];
    [label setShadowColor:[UIColor blackColor]];
    [label setShadowOffset:CGSizeMake(1, 1)];
    [view addSubview:label];
    
    UIView *boxIos = [[UIView alloc] initWithFrame:CGRectMake(5, 120, 310, 350)];
    boxIos.layer.cornerRadius = 10;
    boxIos.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    [view addSubview:boxIos];
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 310, 50)];
    tempLabel.text = @" iOS : godyZ  HongWuZhao ";
    tempLabel.textColor = [UIColor whiteColor];
    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    tempLabel.backgroundColor = [UIColor clearColor];
    [boxIos addSubview:tempLabel];
    
    
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 310, 50)];
    tempLabel.text = @" Android : LiKe ";
    tempLabel.textColor = [UIColor lightGrayColor];
    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    tempLabel.backgroundColor = [UIColor clearColor];
    [boxIos addSubview:tempLabel];

    
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 80, 310, 50)];
    tempLabel.text = @" Background : ShuangjiangLi ";
    tempLabel.textColor = [UIColor whiteColor];
    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    tempLabel.backgroundColor = [UIColor clearColor];
    [boxIos addSubview:tempLabel];
    
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 120, 310, 50)];
    tempLabel.text = @" art designing : PanChen ";
    tempLabel.textColor = [UIColor lightGrayColor];
    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    tempLabel.backgroundColor = [UIColor clearColor];
    [boxIos addSubview:tempLabel];
//
//    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 310, 50)];
//    tempLabel.text = @" art designing : PanChen ";
//    tempLabel.textColor = [UIColor whiteColor];
//    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:21]];
//    tempLabel.backgroundColor = [UIColor clearColor];
//    [yunYinLabel addSubview:tempLabel];
//    
//    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 80, 310, 50)];
//    tempLabel.text = @" art designing : PanChen ";
//    tempLabel.textColor = [UIColor whiteColor];
//    [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:21]];
//    tempLabel.backgroundColor = [UIColor clearColor];
//    [yunYinLabel addSubview:tempLabel];

    
    
    
    
    return view;
}

- (void)viewWillLayoutSubviews
{
    [_glassScrollView setTopLayoutGuideLength:[self.topLayoutGuide length]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showLeftMenu
{
    
    if (!_sideMenu) {
        
        RESideMenuItem *newsItem = [[RESideMenuItem alloc] initWithTitle:@"资讯" image:[UIImage imageNamed:@"资讯"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                    {
                                        if (!HFcampusDelegate.globalNewsNavigationController) {
                                            HFcampusDelegate.globalNewsNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"newsNavigationController"];
                                        }
                                        [menu setRootViewController:HFcampusDelegate.globalNewsNavigationController];
                                    }];
        
        RESideMenuItem *personsItem = [[RESideMenuItem alloc] initWithTitle:@"人物" image:[UIImage imageNamed:@"人物"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                       {
                                           if (!HFcampusDelegate.globalPersonsNavigationController) {
                                               HFcampusDelegate.globalPersonsNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"personsNavigationController"];
                                           }
                                           [menu setRootViewController:HFcampusDelegate.globalPersonsNavigationController];
                                       }];
        RESideMenuItem *topicsItem = [[RESideMenuItem alloc] initWithTitle:@"投票" image:[UIImage imageNamed:@"投票"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                      {
                                          if (!HFcampusDelegate.globalTopicNavigationController)
                                          {
                                              HFcampusDelegate.globalTopicNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                                                                  instantiateViewControllerWithIdentifier:@"topicsNavigationController"];
                                          }
                                          [menu setRootViewController:HFcampusDelegate.globalTopicNavigationController];
                                      }];
        
        RESideMenuItem *algorithmsItem = [[RESideMenuItem alloc] initWithTitle:@"算法" image:[UIImage imageNamed:@"算法"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                          {
                                              if (!HFcampusDelegate.globalAlgorithmNavigationController){
                                                  HFcampusDelegate.globalAlgorithmNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AlgorithmNavigationController"];
                                              }
                                              [menu setRootViewController:HFcampusDelegate.globalAlgorithmNavigationController];
                                          }];
        
        RESideMenuItem *booksSearcher = [[RESideMenuItem alloc] initWithTitle:@"图书查询" image:[UIImage imageNamed:@"书籍查询"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                         {
                                             if (!HFcampusDelegate.globalBooksSearchNavigationController) {
                                                 HFcampusDelegate.globalBooksSearchNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BookSearchNavigationController"];
                                             }
                                             [menu setRootViewController:HFcampusDelegate.globalBooksSearchNavigationController];
                                         }];
        
        RESideMenuItem *expressSearcher = [[RESideMenuItem alloc] initWithTitle:@"快递查询" image:[UIImage imageNamed:@"快递查询"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                           {
                                               if (!HFcampusDelegate.globalExpressSearchNavigationController)
                                               {
                                                   HFcampusDelegate.globalExpressSearchNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpressSearchNavigationControllerID"];
                                               }
                                               [menu setRootViewController:HFcampusDelegate.globalExpressSearchNavigationController];
                                               
                                           }];
        RESideMenuItem *phonesSearcher = [[RESideMenuItem alloc] initWithTitle:@"电话查询" image:[UIImage imageNamed:@"电话查询"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                          {
                                              if (!HFcampusDelegate.globalPhoneSearchNavigationController) {
                                                  HFcampusDelegate.globalPhoneSearchNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PhoneSearchNavigationController"];
                                              }
                                              [menu setRootViewController:HFcampusDelegate.globalPhoneSearchNavigationController];
                                              
                                          }];
        
        RESideMenuItem *toolsItem = [[RESideMenuItem alloc] initWithTitle:@"工具" image:[UIImage imageNamed:@"工具"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                     {
                                         
                                     }];
        toolsItem.subItems  = @[booksSearcher, expressSearcher, phonesSearcher];
        
        RESideMenuItem *aboutItem = [[RESideMenuItem alloc] initWithTitle:@"关于" image:[UIImage imageNamed:@"关于"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                     {
                                         if(!HFcampusDelegate.globalAboutUsNavigationController)
                                         {
                                             HFcampusDelegate.globalAboutUsNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUsNavigationControllerID"];
                                         }
                                         [menu setRootViewController:HFcampusDelegate.globalAboutUsNavigationController];
                                     }];
        
        _sideMenu = [[RESideMenu alloc] initWithItems:@[newsItem, personsItem, topicsItem,algorithmsItem, toolsItem,aboutItem]];
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 45: 45;
    }
    
    [_sideMenu show];
}

# pragma mark - 显示右边栏
-(void)showRightMenu
{
    
}


@end
