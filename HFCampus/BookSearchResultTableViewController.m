//
//  BookSearchResultTableViewController.m
//  HFCampus
//
//  Created by zhangrongjian on 14-1-18.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import "BookSearchResultTableViewController.h"
#import "BookSearchHelper.h"
#import "BooksListCell.h"
#import "BookContentViewController.h"

@interface BookSearchResultTableViewController ()

@end

@implementation BookSearchResultTableViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navi gationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.booklistArray.count <= 0) {
        return 1;
    }
    return [self.booklistArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    #warning 无法使用storyboard 直接 [[tableView dequeueReusableCellWithIdentifier:@" " forIndexPath] signal SIGBAT
    static NSString *CellIdentifier = @"BookListCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = kLeftSelectColor;
        
    }
    
    if (self.booklistArray.count <= 0)
    {
         cell.textLabel.text = @"没找到图书数据!";
    }
    else
    {
        cell.textLabel.text = [[self.booklistArray objectAtIndex:indexPath.row] objectForKey:kbDicKeyTitle];
        cell.detailTextLabel.text = [[self.booklistArray objectAtIndex:indexPath.row] objectForKey:kbDicKeyTime];
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.numberOfLines = 2;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        //如果没有url

    }

    return cell;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 70;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.booklistArray.count <= 0)
    {
        return;
    }
    NSString *urlStr = [[self.booklistArray objectAtIndex:indexPath.row] objectForKey:kbDicKeyURL];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"{" withString:@"\%7B"];  //规整
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"}" withString:@"\%7D"];
    
    NSLog(@"%@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr]; //请求url
    
    NSString *htmlStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];  //获取网页
    
    NSString *infoHtml = [BookSearchHelper bookInfoFromHtml:htmlStr];  //提取bookInfo的html片段
    
    if (infoHtml != nil) {
        
         UIViewController *content = [BookSearchHelper viewcontrollerFromHtml:infoHtml];
         [self.navigationController pushViewController:content animated:YES];
        return;
    }
    
    [[[UIAlertView alloc]initWithTitle:@""
                         message:@"无法提取图书信息"
                         delegate:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil] show];
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
