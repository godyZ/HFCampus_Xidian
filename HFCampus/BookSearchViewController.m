//
//  BookSearchViewController.m
//  HFCampus
//
//  Created by zhangrongjian on 14-1-18.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import "BookSearchViewController.h"
#import "AppDelegate.h"
#import "BookSearchResultTableViewController.h"

#import "BookSearchHelper.h"
#define offset 250

@interface BookSearchViewController ()

@end

@implementation BookSearchViewController

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

    self.navigationController.navigationBar.barTintColor = colorNavBarTint;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,200,100)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:24];
    titleLabel.text = @"书籍查询";
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"general"] style:UIBarButtonItemStylePlain target:self action:@selector(showRightMenu)];
    
    
    [self.CodeBarButton setImage:[UIImage imageNamed:@"barcode"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 功能按键

- (IBAction)KeyOrISBNChanged:(id)sender
{
    [self.KeyOrISBNTextField resignFirstResponder];
    
    switch (self.KeyOrISBNSegment.selectedSegmentIndex )
    {
        case 0:
            self.KeyOrISBNTextField.text = @"";
            self.KeyOrISBNTextField.keyboardType = UIKeyboardTypeDefault;
            self.KeyOrISBNTextField.placeholder = @"请输入关键字";
            break;
        case 1:
            self.KeyOrISBNTextField.text = @"";
            self.KeyOrISBNTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.KeyOrISBNTextField.placeholder = @"请输入ISBN";
            break;
            
        default:
            break;
    }
}

- (IBAction)SearchButtonPress:(id)sender
{
    
    NSString *key = self.KeyOrISBNTextField.text;
    key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (key.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"输入点东西吧."];
        self.KeyOrISBNTextField.text = @"";
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [self loadBookHtmlForKey:key];
    [SVProgressHUD dismiss];
}

-(void)loadBookHtmlForKey:(NSString *)key
{
    NSString *webHtmlStr;
    
    //加载中
    [SVProgressHUD showWithStatus:@"查询中"];
    switch (self.KeyOrISBNSegment.selectedSegmentIndex ) {
        case 0:
            //关键字
            webHtmlStr = [BookSearchHelper bookHtmlFromKeyword:key withPage:0];
            break;
        case 1:
            //ISBN
            webHtmlStr = [BookSearchHelper bookHtmlFromISBN:key withPage:0];
            break;
            
        default:
            return;
            break;
    }
    
    if (webHtmlStr == nil) {
        [SVProgressHUD setStatus:@"网络错误!"];
        return;
    }
    
    [SVProgressHUD dismiss];
    
    NSString *infoHtml = [BookSearchHelper bookInfoFromHtml:webHtmlStr];
    
    if (infoHtml != nil)   //如果可以提取图书介绍信息，那么直接进入页面
    {
        UIViewController *content = [BookSearchHelper viewcontrollerFromHtml:infoHtml];
        [self.navigationController pushViewController:content animated:YES];
        return;
    }
    
    NSArray *array = [BookSearchHelper bookListFromHtml:webHtmlStr];
    BookSearchResultTableViewController *bl = [[BookSearchResultTableViewController alloc] init];
    bl.booklistArray = array;
    
    [self.navigationController pushViewController:bl animated:YES];
    
    
}


- (IBAction)CodeBarPress:(id)sender    //条码扫描
{
    [super viewDidLoad];

    self.scanBackGroundView.hidden = NO;
    self.scanBackGroundView.backgroundColor = [UIColor grayColor];
    self.scanBackGroundView.alpha = 0.9f;

    
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    [scanButton setTintColor:[UIColor blueColor]];
    scanButton.frame = CGRectMake(230, 60, 120, 40);
    [scanButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scanBackGroundView addSubview:scanButton];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 40 + offset + 13 , 300, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines = 2;
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"请将条码置于方框内";
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    [self.scanBackGroundView addSubview:labIntroudction];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100 + offset, 300, 200)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.scanBackGroundView addSubview:imageView];
    
    self.upOrdown = NO;
    self.num = 0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110 + offset, 220, 1)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.scanBackGroundView addSubview:_line];
    
   self.timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [self setupCamera];
    
}
- (void)cancelAction
{
    [_line removeFromSuperview];
    [self.timer invalidate];
    [_session stopRunning];
    [self.preview removeFromSuperlayer];
    self.scanBackGroundView.hidden = YES;
}

-(void)animation1
{
    if (self.upOrdown == NO) {
        self.num ++;
        _line.frame = CGRectMake(50, 110 + offset + 2 * self.num, 220, 2);
        if (2*self.num == 180 ) {
            self.upOrdown = YES;
        }
    }
    else {
        self.num --;
        _line.frame = CGRectMake(50, 110 + offset + 2 * self.num, 220, 2);
        if (self.num == 0 ) {
            self.upOrdown = NO;
        }
    }
    
}

- (void)setupCamera    //摄像头设置
{
    // Device
    self.scanISBNStringValue = nil;
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(10, 100 + offset, 300, 200);
    [self.scanBackGroundView.layer insertSublayer:self.preview atIndex:0];
    
    
    
    // Start
    [_session startRunning];
}




- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (self.scanISBNStringValue) {
        return;
    }
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        self.scanISBNStringValue = metadataObject.stringValue;
    }
    
    [self cancelAction];
    
    NSString *webHtmlStr = [BookSearchHelper bookHtmlFromISBN:self.scanISBNStringValue withPage:0];
    
    if (webHtmlStr == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"网络错误!"];
        return;
    }
    //[SVProgressHUD showWithStatus:[NSString stringWithFormat:@"书号: %@",self.scanISBNStringValue]];
    NSString *infoHtml = [BookSearchHelper bookInfoFromHtml:webHtmlStr];
    
    if (infoHtml != nil)
    {
        UIViewController *content = [BookSearchHelper viewcontrollerFromHtml:infoHtml];
        [self.navigationController pushViewController:content animated:YES];
        return;
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"图书馆无该图书" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil] show];
        return;
    }
}


#pragma mark - 显示左边栏

-(void)showLeftMenu
{
    
    if (!_sideMenu) {
        RESideMenuItem *newsItem = [[RESideMenuItem alloc] initWithTitle:@"资讯" action:^(RESideMenu *menu, RESideMenuItem *item) {
            if (!HFcampusDelegate.globalNewsNavigationController) {
                HFcampusDelegate.globalNewsNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"newsNavigationController"];
            }
            [menu setRootViewController:HFcampusDelegate.globalNewsNavigationController];
        }];
        RESideMenuItem *personsItem = [[RESideMenuItem alloc] initWithTitle:@"人物" action:^(RESideMenu *menu, RESideMenuItem *item) {
            if (!HFcampusDelegate.globalPersonsNavigationController) {
                HFcampusDelegate.globalPersonsNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"personsNavigationController"];
            }
            [menu setRootViewController:HFcampusDelegate.globalPersonsNavigationController];
        }];
        RESideMenuItem *topicsItem = [[RESideMenuItem alloc] initWithTitle:@"话题" action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            
        }];
        RESideMenuItem *picturesItem = [[RESideMenuItem alloc] initWithTitle:@"图说" action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            NSLog(@"Item %@", item);
        }];
        RESideMenuItem *algorithmsItem = [[RESideMenuItem alloc] initWithTitle:@"算法" action:^(RESideMenu *menu, RESideMenuItem *item) {
            if (!HFcampusDelegate.globalAlgorithmNavigationController){
                HFcampusDelegate.globalAlgorithmNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AlgorithmNavigationController"];
            }
            [menu setRootViewController:HFcampusDelegate.globalAlgorithmNavigationController];
        }];
        
        RESideMenuItem *booksSearcher = [[RESideMenuItem alloc] initWithTitle:@"图书查询" action:^(RESideMenu *menu, RESideMenuItem *item) {
            if (!HFcampusDelegate.globalBooksSearchNavigationController) {
                HFcampusDelegate.globalBooksSearchNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BookSearchNavigationController"];
            }
            [menu setRootViewController:HFcampusDelegate.globalBooksSearchNavigationController];
        }];
        
        RESideMenuItem *expressSearcher = [[RESideMenuItem alloc] initWithTitle:@"快递查询" action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            [menu hide];
        }];
        RESideMenuItem *phonesSearcher = [[RESideMenuItem alloc] initWithTitle:@"电话查询" action:^(RESideMenu *menu, RESideMenuItem *item) {
            if (!HFcampusDelegate.globalPhoneSearchNavigationController) {
                HFcampusDelegate.globalPhoneSearchNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PhoneSearchNavigationController"];
            }
            [menu setRootViewController:HFcampusDelegate.globalPhoneSearchNavigationController];
            
        }];
        
        RESideMenuItem *toolsItem = [[RESideMenuItem alloc] initWithTitle:@"工具" action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
        }];
        toolsItem.subItems  = @[booksSearcher, expressSearcher, phonesSearcher];
        
        RESideMenuItem *aboutItem = [[RESideMenuItem alloc] initWithTitle:@"关于" action:^(RESideMenu *menu, RESideMenuItem *item) {
            
        }];
        
        _sideMenu = [[RESideMenu alloc] initWithItems:@[newsItem, personsItem, topicsItem, picturesItem,algorithmsItem, toolsItem,aboutItem]];
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 45: 76;
    }
    
    [_sideMenu show];
}

# pragma mark - 显示右边栏
-(void)showRightMenu
{
    
}





@end
