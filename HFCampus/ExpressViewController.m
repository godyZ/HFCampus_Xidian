//
//  ExpressViewController.m
//  HFCampus
//
//  Created by zhangrongjian on 14-1-23.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import "ExpressViewController.h"
#import "AppDelegate.h"
#import "HiHelper.h"
#import "UIViewController+MJPopupViewController.h"

#define offset 250

@interface ExpressViewController ()

@end

@implementation ExpressViewController

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
    titleLabel.text = @"快递查询";
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"general"] style:UIBarButtonItemStylePlain target:self action:@selector(showRightMenu)];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CloseKeyBoard:(id)sender
{
    [self.numTextField resignFirstResponder];
}

- (IBAction)ScanButton:(id)sender
{
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
    
    
    UIImageView * imageView;
    
    if (IS_WIDESCREEN) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100 + offset, 300, 200)];
    }else{
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100 + offset, 300, 100)];
    }
    
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

- (void)animation1
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
    if (IS_WIDESCREEN) {
        _preview.frame = CGRectMake(10, 100 + offset, 300, 200);
    }
    else{
        _preview.frame = CGRectMake(10, 100 + offset, 300, 100);
    }
    
    [self.scanBackGroundView.layer insertSublayer:self.preview atIndex:0];
    
    
    
    // Start
    [_session startRunning];
}

- (IBAction)SearchOk:(id)sender
{
    [self showExpressView:self.numTextField.text];

}


# pragma mark -<AVCaptureMetadataOutputObjectsDelegate>
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
    
    [self showExpressView:self.scanISBNStringValue];

}


#pragma mark 功能函数
-(void)showExpressView:(NSString *)num
{
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeNone];
    
    NSString *htmlStr = [self getExpressHtmlFromNum:num];
    
    NSString *info = [NSString stringWithFormat:@"<span style=\"color:red\">%@</span><br><hr>%@",
                      [self getExpressNameFromHtml:htmlStr],[self getExpressInfoFromHtml:htmlStr]];
    if (!self.infoWeb) {
        self.infoWeb = [[UIWebView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    }
    [self.infoWeb loadHTMLString:info baseURL:nil];
    
    [self presentPopupView:self.infoWeb animationType:MJPopupViewAnimationSlideBottomTop];
    
    [SVProgressHUD dismiss];
}

-(NSString *)getExpressHtmlFromNum:(NSString *)num
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.wochacha.com/express/search?barcode=%@", num]];
    NSError *error;
    NSString *htmlStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error)
    {
        NSLog(@"请求快递信息出现错误, 代码:%ld, 描述:%@", error.code,(NSString *)error.localizedDescription);
        return @"";
    }
    //NSLog(@"%@", htmlStr);
    return htmlStr;
}

-(NSString *)getExpressNameFromNum:(NSString*)num  //获得快递名称
{
    NSString *htmlStr = [self getExpressHtmlFromNum:num];
    NSString *regString = @"(?<=<div>您查询的是)\\w+(?=的快递单</div>)";
    
    return [HiHelper stringFormString:htmlStr withRegular:regString];
}

-(NSString *)getExpressInfoFromNum:(NSString*)num  //获得快递物流详情
{
    NSString *htmlStr = [self getExpressHtmlFromNum:num];
    NSString *regString = @"(?<=<div id=\"expr_list\">).+(?=</div>)";
    
    return [HiHelper stringFormString:htmlStr withRegular:regString];
}

-(NSString *)getExpressNameFromHtml:(NSString*)htmlStr  //获得快递名称
{
    NSString *regString = @"(?<=<div>您查询的是)\\w+(?=的快递单</div>)";
    
    return [HiHelper stringFormString:htmlStr withRegular:regString];
}

-(NSString *)getExpressInfoFromHtml:(NSString*)htmlStr  //获得快递物流详情
{
    NSString *regString = @"(?<=<div id=\"expr_list\">).+(?=</div>)";
    
    return [HiHelper stringFormString:htmlStr withRegular:regString];
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
