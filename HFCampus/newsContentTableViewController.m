//
//  newsContentTableViewController.m
//  HFCampus
//
//  Created by zhangrongjian on 13-12-26.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#import "newsContentTableViewController.h"
#import "AppDelegate.h"
#import "NewsLineCell.h"
#import "TopLineCell.h"
#import "IndicatorTableViewCell.h"
#import "NewsContentViewController.h"

@interface newsContentTableViewController () <UIScrollViewDelegate>

@property (strong, nonatomic)NSMutableArray *menuItems;
@property (strong, nonatomic)UIActivityIndicatorView *loadMoreIndicatorView;

-(void)GetMenuItems;
-(void)LoadMore;

@end

@implementation newsContentTableViewController

#pragma mark - 初始化
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.isNoMore = NO;
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isNoMore = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor redColor];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.tableView reloadData];
    
    [self GetMenuItems];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 下拉刷新
- (void)RefreshViewControlEventValueChanged
{
    [self GetMenuItems];
    [self performSelector:@selector(handleData) withObject:nil afterDelay:3];
}
- (void)handleData
{
    [self.refreshControl endRefreshing];
}

#pragma mark - 网络获取
- (void)GetMenuItems
{
    [self.loadMoreIndicatorView startAnimating];    //加载动画
    NSString *urlStr = [NSString stringWithFormat:@"list/%@/%@", self.newsType, CAMPUS_ID];
    NSURL *url = [NSURL URLWithString:urlStr];
    DLog(@"url is %@", url);
    
    [HFcampusDelegate.restfulEngine fetchMenuItemsForPath:urlStr
                                                onSucceed:^(NSMutableArray *listOfModelBaseObjects){
                                                    [self.loadMoreIndicatorView stopAnimating];
                                                    self.menuItems = listOfModelBaseObjects;
                                                    if([self.menuItems count] > 0){
                                                        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                                                        [self.tableView reloadData];
                                                    }
                                                } onError:^(NSError *engineError) {
                                                    
                                                    [UIAlertView showWithError:engineError];
    
                                                }];
}

-(void)LoadMore
{
    [self.loadMoreIndicatorView startAnimating];
    MenuItem *menuItem = [self.menuItems objectAtIndex:[self.menuItems count]-1];
    if (menuItem.itemId) {
        NSString *urlPath = [NSString stringWithFormat:@"list/%@/%@/%@", self.newsType, CAMPUS_ID, menuItem.itemId];
        [HFcampusDelegate.restfulEngine fetchMenuItemsForPath:urlPath
                                                    onSucceed:^(NSMutableArray *listOfModelObjects) {
                                                        [self.loadMoreIndicatorView stopAnimating];
                                                        if([listOfModelObjects count] == 0) //最后一个没有了
                                                        {
                                                            self.isNoMore = YES;
                                                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.menuItems count] inSection:0];
                                                            NSArray *indexArray = [NSArray arrayWithObjects:indexPath, nil];
                                                            [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
                                                        }
                                                        else{     //暂时还有
                                                            
                                                            NSUInteger insertStart = [self.menuItems count];
                                                            [self.menuItems addObjectsFromArray:listOfModelObjects];
                                                            //插入新增加的列表数据
                                                            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:listOfModelObjects.count];
                                                            
                                                            for (NSUInteger ind = insertStart; ind < insertStart + [listOfModelObjects count]; ind++)
                                                            {
                                                                NSIndexPath *newPath = [NSIndexPath indexPathForRow:ind inSection:0];
                                                                [insertIndexPaths addObject:newPath];
                                                            }
                                                            //insertPaths时 自动会 reloadTableData, 从menusItems中
                                                            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                                                            
                                                        }
                                                    } onError:^(NSError *engineError) {
                                                        [UIAlertView showWithError:engineError];
                                                    }];
    }
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count + 3;  // +1 是topic  +1 是 loadmore +1是空白
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float value = 0;
    if(indexPath.row == 0)
    {
        value = TopLineCellHeight;
    }
    else if(indexPath.row == self.menuItems.count + 1)
    {
        value = LoadMoreCellHeight;
    }
    else
    {
        value = NewsLineCellHeight;
    }
    return value;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = NULL;
    
    if(indexPath.row == 0)
    {
        CellIdentifier = @"TopLineImages";
        TopLineCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.row == [self.menuItems count] + 2)  //最后一行留空，防止弹回
    {
        CellIdentifier = @"loadMoreCell";
        IndicatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.loadMoreLabel.text = @"";
        cell.loadMoreIndicator.hidden = YES;
        return cell;
    }
    else if (indexPath.row == ([self.menuItems count] + 1))
    {
        CellIdentifier = @"loadMoreCell";
        IndicatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        self.loadMoreIndicatorView = cell.loadMoreIndicator;
        if (!self.isNoMore)
        {
            cell.loadMoreLabel.text = @"加载中...";
            cell.loadMoreIndicator.hidden = NO;
            [self LoadMore];
        }
        else
        {
            cell.loadMoreLabel.text = @"没有更多数据";
        }
        return cell;
    }
    else //正常新闻menulist
    {
        CellIdentifier = @"newsLines";
        NewsLineCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        MenuItem *item  = [self.menuItems objectAtIndex:indexPath.row -1 ];
        cell.newsTitle.text = item.title;
    
#warning this is the wrong time
        NSTimeInterval dateInt = [[item.create_time objectForKey:@"$date"] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateInt];
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        dateFormater.dateFormat = @"MM-dd";
    
        cell.newsDescription.text = [NSString stringWithFormat:@"%@ | %@",item.author_name,[dateFormater stringFromDate:date]];
        
        cell.newsThumbnailImage.layer.cornerRadius = 4.0f;
        cell.newsThumbnailImage.layer.masksToBounds = YES;
        cell.newsThumbnailImage.layer.borderWidth = 0.2f ;
        NSString *imgURL = [NSString stringWithFormat:@"%@/mobile/thumbnail/mid/%@", kHiMainURL,item.thumbnail];
        [cell.newsThumbnailImage setImageWithURL:[NSURL URLWithString:imgURL]];
    
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MenuItem *tempItem = [self.menuItems objectAtIndex:indexPath.row - 1];
    NewsContentViewController *newsContentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsContentViewController"];
    
    if([self.newsType isEqualToString:@"lecture"]){
        newsContentVC.contentType = 2;
    }
    else{
        newsContentVC.contentType = 1;
    }
    newsContentVC.item = tempItem;
    newsContentVC.path = [NSString stringWithFormat:@"/detail/%@/%@",self.newsType,tempItem.itemId];
   
    [self.originalNavigationController pushViewController:newsContentVC animated:YES];
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
