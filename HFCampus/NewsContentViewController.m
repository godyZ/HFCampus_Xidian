//
//  NewsContentViewController.m
//  HFCampus
//
//  Created by zhangrongjian on 13-12-30.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#import "NewsContentViewController.h"
#import "FileHelper.h"
#import "ViewPagerController.h"

@interface NewsContentViewController ()

@property (strong, nonatomic) UINavigationBar *originalBar;
@property (strong, nonatomic) UINavigationItem *originalItem;

@end

@implementation NewsContentViewController

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
        self.contentType = 1;
        self.navigationController.navigationBar.tintColor = colorNavBarTint;
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    switch (self.contentType) {
        case 1:
            [self getNewsDetail];
            break;
        case 2:
            [self getLectureDetail];
            break;
        default:
            break;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跟帖" style:UIBarButtonItemStylePlain target:self action:@selector(gentie)];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self followScrollView:self.contentWebView];
    self.originalBar = self.navigationController.navigationBar;
    self.originalItem = self.navigationItem;
     self.navigationController.delegate = self;
    [SVProgressHUD showWithStatus:@"加载中..."];
}
- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)gentie
{
    
}

-(void)getNewsDetail{
    NSString *htmlFileName;
    __block NSString *htmlStr;
    htmlFileName = @"news.html";
    
    NSString *htmlPath = [FileHelper pathFromNamed:htmlFileName];
    htmlStr = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    /*
     新闻标题与时间等
     */
    NSString *contentTitle = self.item.title;
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"#title#" withString:contentTitle];
    
    NSTimeInterval dateInt = [[self.item.create_time objectForKey:@"$date"] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateInt/1000];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat = @"MM月dd日 hh:mm";
    
    NSString *time = [dateFormater stringFromDate:date];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"#create_time#" withString:time];
    
    [HFcampusDelegate.restfulEngine fetchDetailForPath:self.path onSucceed:^(DetailItem *aDetailItem) {
        DLog(@"content %@",aDetailItem.content);
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"#content#" withString:aDetailItem.content];
        [self.contentWebView loadHTMLString:htmlStr baseURL:nil];
        [SVProgressHUD dismiss];
    } onError:^(NSError *engineError) {
        [UIAlertView showWithError:engineError];
        [self.contentWebView loadHTMLString:htmlStr baseURL:nil];
        [SVProgressHUD dismiss];
    }];
}

/*
 招聘详情
 */
- (void)getLectureDetail{
    NSString *htmlFileName;
    __block NSString *htmlStr;
    
    htmlFileName = @"activity.html";
    
    NSString *path = [FileHelper pathFromNamed:htmlFileName];
    htmlStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSString *person = self.item.person;
    NSString *contentTitle = self.item.title;
    NSString *place = self.item.place;
    NSTimeInterval dateInt = [[self.item.start_time objectForKey:@"$date"]doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateInt];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat = @"MM月dd日 hh:mm";
    
    NSString *time = [dateFormater stringFromDate:date];
    
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"#person#" withString:person];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"#place#" withString:place];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"#start_time#" withString:time];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"#title#" withString:contentTitle];
    
    self.shareString = [NSString stringWithFormat:@"讲座:%@ -- 时间: %@ -- 地点: %@", contentTitle, place, time];
    
    NSTimeInterval dateInt1 = [[self.item.create_time objectForKey:@"$date"]doubleValue];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:dateInt1];
    dateFormater.dateFormat = @"MM月dd日 hh:mm";
    NSString *time1 = [dateFormater stringFromDate:date1];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"#create_time#" withString:time1];
    /*
     <h2>#title#</h2>
     <p>发布日期:#create_time#</p>
     <p>人物: <span class="po">#person#</span></p>
     <p>时间: <span class="po">#start_time#</span></p>
     <p>地点: <span class="po">#place#</span></p>
     <p>-------------------</p>
     <div class=content>#content#</div>
     */
    [HFcampusDelegate.restfulEngine fetchDetailForPath:self.path onSucceed:^(DetailItem *aDetailItem) {
        DLog(@"content %@",aDetailItem.content);
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"#content#" withString:aDetailItem.content];
        [self.contentWebView loadHTMLString:htmlStr baseURL:nil];
        [SVProgressHUD dismiss];
    } onError:^(NSError *engineError) {
        [UIAlertView showWithError:engineError];
        [self.contentWebView loadHTMLString:htmlStr baseURL:nil];
        [SVProgressHUD dismiss];
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //防止回退bug
    if ([viewController isKindOfClass:[ViewPagerController class]])
    {
        [SVProgressHUD dismiss];
        self.navigationController.navigationBar.frame = CGRectMake(0,20, 320, 44);
        [self checkForPartialScroll];
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  
}







@end
