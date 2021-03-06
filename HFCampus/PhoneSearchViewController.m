//
//  PhoneSearchViewController.m
//  HFCampus
//
//  Created by zhangrongjian on 14-1-17.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import "AppDelegate.h"
#import "PhoneSearchViewController.h"
#import "XMLDictionary.h"

@interface PhoneSearchViewController ()

@end

@implementation PhoneSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

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
    titleLabel.text = @"电话查询";
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"general"] style:UIBarButtonItemStylePlain target:self action:@selector(showRightMenu)];
    
    [self.phoneTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self SchoolPhone:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 功能函数
-(NSArray *) dataArrayFromType:(NSInteger) type
{
    NSString *path =[[NSBundle mainBundle] pathForResource:@"phone_number" ofType:@"xml"];
    NSDictionary * phoneDic = [NSDictionary dictionaryWithXMLFile:path];
    NSLog(@"phone_number : %@", phoneDic);
    
    NSArray *allArray = [phoneDic objectForKey:@"num"];
    NSMutableArray *rArray = [[NSMutableArray alloc] initWithCapacity:allArray.count];
    
    for (int i = 0; i < allArray.count; i++) {
        if ([[[allArray objectAtIndex:i] objectForKey:@"_type"] integerValue] == type) {
            [rArray addObject:[allArray objectAtIndex:i]];
        }
    }
    return rArray;
}

-(void)allBtnNoCheck
{
    for (int i = 100; i <= 104; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        //[btn setBackgroundImage:[UIImage imageNamed:@"hi_phone_nocheck.png"] forState:UIControlStateNormal];
        [btn setTintColor:PhoneNoSelectedColor];
    }
    
}

-(void)btnCheckedWithTag:(NSInteger)tag
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
    //[btn setBackgroundImage:[UIImage imageNamed:@"hi_phone_checked.png"] forState:UIControlStateNormal];
    [btn setTintColor:[UIColor redColor]];
}

- (IBAction)SchoolPhone:(id)sender
{
    [self allBtnNoCheck];
    [self btnCheckedWithTag:100];
    self.dataArray = [self dataArrayFromType:1];//[HiUserHelper getUserSchool]];
    
    [self.phoneTableView reloadData];
}



- (IBAction)OtherPhoneTouch:(id)sender
{
    NSInteger tag = ((UIButton *)sender).tag;
    
    [self allBtnNoCheck];
    [self btnCheckedWithTag:tag];
    
    self.dataArray = [self dataArrayFromType:tag];
    [self.phoneTableView reloadData];
    
    //将scrollview 移动到顶部
    [self.phoneTableView setContentOffset:CGPointMake(0, 0) animated:NO];
}



# pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"phoneCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        //字体相关
        //cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.imageView.image = [UIImage imageNamed:@"hiphone.png"];
        //选择后的背景
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = kLeftSelectColor;
    }
    
    cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"_name"];
    cell.detailTextLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"__text"];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@", [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"__text"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}

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
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 45: 76;
    }
    
    [_sideMenu show];
}

# pragma mark - 显示右边栏
-(void)showRightMenu
{
    
}

@end
