//
//  PersonContentViewController.m
//  HFCampus
//
//  Created by zhangrongjian on 14-1-3.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import "PersonContentViewController.h"
#import "PersonIntroductionCell.h"
#import "PeronContentImageCell.h"
#import "AppDelegate.h"

@interface PersonContentViewController ()

@property (assign, nonatomic) float webHight;
@property (assign, nonatomic) bool isWebViewload;
@property (copy, nonatomic) NSString *webViewContent;

@end

@implementation PersonContentViewController

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
    if(self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,150,100)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Arial" size:20];
    titleLabel.text = self.personName;
    self.navigationItem.titleView = titleLabel;
    self.webHight = 300.0f;
    self.isWebViewload = NO;
    
    //follow view
    [self.navigationController.navigationBar setTranslucent:NO];
    [self followScrollView:self.contentTableView];
    self.navigationController.delegate = self;
    
    [SVProgressHUD showWithStatus:@"加载中..."];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0 == indexPath.row)
    {
        
        return 200;
    }
    else
    {
#warning 暂时定为300
        return self.webHight + 100;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = NULL;

    if(0 == indexPath.row)
    {
        CellIdentifier = @"PersonContentImageCell";
        PeronContentImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.personLargerThumbnail.image = self.personLargeThumbnail;


        cell.personQuotation.text = self.personQuotation;
        cell.infoBox.layer.cornerRadius = 6.0f;
        [cell.PersonSmallThumbnail setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mobile/thumbnail/big/%@",kHiMainURL,self.thumbnail2]]];
        return cell;
    }
    else 
    {
        CellIdentifier = @"PersonIntroductionCell";
        PersonIntroductionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.title.text = self.title;
        
        if (self.webHight != 300)      //已经读取过一次 （高度已经改变了）
        {
            if (!self.isWebViewload)
            {
                [cell.webViewContent loadHTMLString:self.webViewContent baseURL:nil];
            }
            self.isWebViewload = YES;
        }
        else    //self.webHight == 300  第一次
        {
            [HFcampusDelegate.restfulEngine fetchDetailForPath:self.detailPersonURL onSucceed:^(DetailItem *aDetailItem) {
                
                cell.webViewContent.delegate = self;
                [(UIScrollView *)[[cell.webViewContent subviews] objectAtIndex:0] setBounces:NO];
                self.webViewContent = aDetailItem.content;
                [cell.webViewContent loadHTMLString:self.webViewContent baseURL:nil];
                [SVProgressHUD dismiss];
                
            } onError:^(NSError *engineError) {
                [UIAlertView showWithError:engineError];
                [SVProgressHUD dismiss];
            }];
        }
        return cell;
    }
}


#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - webViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    self.webHight = [string floatValue];

    [self.contentTableView reloadData];
    
    
}

#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [SVProgressHUD dismiss];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ([viewController isKindOfClass:[UITableViewController class]])
    {
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
        [self checkForPartialScroll];
    }
    
}

@end


