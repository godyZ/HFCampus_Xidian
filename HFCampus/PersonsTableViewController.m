//
//  PersonsTableViewController.m
//  HFCampus
//
//  Created by zhangrongjian on 13-12-26.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#import "PersonsTableViewController.h"
#import "AppDelegate.h"
#import "PersonListCell.h"
#import "IndicatorPersonCell.h"
#import "PersonContentViewController.h"

@interface PersonsTableViewController ()

@property (strong,nonatomic) NSMutableArray *peopleItems;
@property (strong,nonatomic) UIImage *largeThumbnail;
@property (strong, nonatomic) UIActivityIndicatorView *loadMoreIndicator;

- (void)GetPersonItems;

@end

@implementation PersonsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:23];
    titleLabel.text = @"每周人物";
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Set"] style:UIBarButtonItemStylePlain target:self action:@selector(showRightMenu)];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor redColor];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   //无分割线
    
    NSData *personTableViewCacheData = [FTWCache objectForKey:@"人物缓存"];   //前十条
    if (personTableViewCacheData) {
        self.peopleItems = [NSKeyedUnarchiver unarchiveObjectWithData:personTableViewCacheData];
    }
    
    [self.tableView reloadData];
    [self GetPersonItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 与下拉刷新有关
- (void)RefreshViewControlEventValueChanged
{
    [self GetPersonItems];
    [self performSelector:@selector(handleData) withObject:nil afterDelay:1];
}
- (void)handleData
{
    [self.refreshControl endRefreshing];
}


#pragma mark - 与网络相关

- (void)GetPersonItems
{
    [self.loadMoreIndicator startAnimating];
    NSString *urlPath = [NSString stringWithFormat:@"list/person/%@", CAMPUS_ID];
    
    [HFcampusDelegate.restfulEngine fetchPeopleItemsForPath:urlPath
                                                  onSucceed:^(NSMutableArray *listOfModelObjects) {
                                                      [self.loadMoreIndicator stopAnimating];
                                                      if ([listOfModelObjects count] > 0) {
                                                          self.peopleItems = [NSMutableArray arrayWithArray:listOfModelObjects];
                                                          self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                                                          [self.tableView reloadData];   //刷新tableViews
                                                          
                                                          //写入缓存
                                                          dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                                                          dispatch_async(queue, ^{
                                                              
                                                              NSData *personTableViewCacheData = [NSKeyedArchiver archivedDataWithRootObject:self.peopleItems];
                                                              
                                                              [FTWCache setObject:personTableViewCacheData forKey:@"人物缓存"];
                                                          });

                                                          
                                                      }
                                                  } onError:^(NSError *engineError) {
                                                      [UIAlertView showWithError:engineError];
                                                  }];
}

-(void)LoadMore //加载更多数据
{
    [self.loadMoreIndicator startAnimating];
    PeopleItem *peopleItem = [self.peopleItems lastObject];
    
    NSString *urlPath = [NSString stringWithFormat:@"list/people/%@/%@",CAMPUS_ID,peopleItem.itemId];
    [HFcampusDelegate.restfulEngine fetchPeopleItemsForPath:urlPath onSucceed:^(NSMutableArray *listOfModelObjects) {
        [self.loadMoreIndicator stopAnimating];
        if ([listOfModelObjects count] == 0) {
            self.isNoMore = YES;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.peopleItems count] inSection:0];
            NSArray *indexArray = [NSArray arrayWithObjects:indexPath, nil];
            [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
        }
        
        else{
            NSUInteger insertStart = [self.peopleItems count];
            [self.peopleItems addObjectsFromArray:listOfModelObjects];
            //插入新增加的列表数据
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:listOfModelObjects.count];
            
            for (NSUInteger ind = insertStart; ind < insertStart + [listOfModelObjects count]; ind++) {
                NSIndexPath *newPath = [NSIndexPath indexPathForRow:ind inSection:0];
                [insertIndexPaths addObject:newPath];
            }
            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    } onError:^(NSError *engineError) {
        self.isNoMore = YES;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.peopleItems count] inSection:0];
        NSArray *indexArray = [NSArray arrayWithObjects:indexPath, nil];
        [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.peopleItems.count == 1) {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.peopleItems.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.peopleItems.count)
    {
        return 200;
    }
    else
    {
        return 75;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = NULL;
    
    if (indexPath.row == ([self.peopleItems count] ))
    {
        CellIdentifier = @"loadMorePersonCell";
        IndicatorPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        self.loadMoreIndicator = cell.loadMoreIndicator;
        
        if (!self.isNoMore) {
            cell.loadMoreLabel.text = @"加载中...";
            cell.loadMoreIndicator.hidden = NO;
            [self LoadMore];
        }
        else{
            cell.loadMoreLabel.text = @"没有更多数据";
        }
        return cell;
    }
    else//正常cell人物信息加载
    {
        CellIdentifier = @"PersonLinesCell";
        PersonListCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        PeopleItem *person = [self.peopleItems objectAtIndex:indexPath.row];
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = [UIColor colorWithWhite:0.96f alpha:1.0f];
        }
        
       
        cell.personName.text = person.person_name;
        cell.personQuotation.text = person.words;
        
        cell.personPeriod.layer.cornerRadius = 2.0f;
        cell.personPeriod.layer.masksToBounds = YES;

        cell.personPeriod.text = [NSString stringWithFormat:@"第%@期",person.time];
        
        if (indexPath.row == 0) {
            cell.personPeriod.text = @"本期人物";
            cell.personPeriod.textColor = [UIColor redColor];
        }
        
        
        cell.personThumbnail.layer.cornerRadius = 4.0f;
        cell.personThumbnail.layer.masksToBounds = YES;
        cell.personThumbnail.layer.borderWidth = 0.2f ;
        NSString *url1Str = [NSString stringWithFormat:@"%@/mobile/thumbnail/big/%@",kHiMainURL,person.thumbnail1];
        [cell.personThumbnail setImageWithURL:[NSURL URLWithString:url1Str]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
                            {
                              self.largeThumbnail = cell.personThumbnail.image;

                            }
         ];
        return cell;
    }
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

#pragma mark - 显示右边栏
-(void)showRightMenu
{
    
}

#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPersonDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PeopleItem *tempPersonItem = [self.peopleItems objectAtIndex:indexPath.row];
        PersonContentViewController *tempController = segue.destinationViewController;
        PersonListCell *tempCell = (PersonListCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [tempController setPersonLargeThumbnail:tempCell.personThumbnail.image];
        [tempController setPersonName:tempPersonItem.person_name];
        [tempController setPersonPeriod:[NSString stringWithFormat:@"第%@期",tempPersonItem.time]];
        [tempController setPersonQuotation:tempPersonItem.words];
        [tempController setTitle:tempPersonItem.title];
        [tempController setDetailPersonURL:[NSString stringWithFormat:@"detail/person/%@", tempPersonItem.itemId]];
        [tempController setThumbnail2:tempPersonItem.thumbnail2];
    }
}





@end
