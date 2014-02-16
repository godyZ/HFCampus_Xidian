//
//  NewsViewController.m
//  HFCampus
//
//  Created by zhangrongjian on 13-12-26.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#import "NewsViewController.h"
#import "newsContentTableViewController.h"
#import "DRNRealTimeBlurView.h"
#import "AppDelegate.h"
#import <UIKit/UIGestureRecognizer.h>

typedef enum  //枚举新闻类型
{
	NEWS, ACTIVITY, JOB, LECTURE, GRAPEVANE
} NewsType;


@interface NewsViewController () <ViewPagerDataSource, ViewPagerDelegate, UIGestureRecognizerDelegate>  //多个controll控制

@property (copy, nonatomic)NSArray *typeArr;  //新闻类别
@property (copy, nonatomic)NSArray *engTypes; //英文类别  用于填补url地址
@property (strong, nonatomic)NSMutableArray *menuItems;
@property (strong, nonatomic)DRNRealTimeBlurView *blurView;
//-(void)getInforForCell:(NSIndexPath *)indexPath;

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.typeArr = [NSArray arrayWithObjects:@"新闻",@"活动",@"招聘",@"讲座",@"八卦",nil];
        self.engTypes = [[NSArray alloc]initWithObjects:@"news",@"activity",@"job",@"lecture",@"grapevane",nil];
        HFcampusDelegate.globalNewsNavigationController = self.navigationController;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = colorNavBarTint;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,200,100)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:24];
    titleLabel.text = @" 资讯";
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"general"] style:UIBarButtonItemStylePlain target:self action:@selector(showRightMenu)];
    
    
//    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPan:)];
//    [self.view addGestureRecognizer:leftPan];
//    
//    

}
//-(void)handleLeftPan:(id)sender
//{
//    
//}




- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTranslucent:YES];  //与AMScrollingNavbar相关
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ViewPagerDataSource 填充页面数据

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.typeArr.count;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = self.typeArr[index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    
    newsContentTableViewController *newsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsContentTVB"];
    newsTVC.newsType = self.engTypes[index];
    newsTVC.originalNavigationController = self.navigationController;
    newsTVC.bigNewsViewController = self;
    return newsTVC;
}


#pragma mark - ViewPagerDelegate 修改页面各方面颜色

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {//值
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabHeight:
            return 30;
            break;
        case ViewPagerOptionTabWidth:
            return 65;
            break;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {//颜色
    
    switch (component) {
        case ViewPagerIndicator:
            return colorChinaRed;
            break;
        default:
            break;
    }
    
    return color;
}



//#pragma mark - UIPageViewControllerDelegate
//- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
//{
//}


#pragma mark - 显示左边栏

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
