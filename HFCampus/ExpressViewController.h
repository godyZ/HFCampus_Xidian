//
//  ExpressViewController.h
//  HFCampus
//
//  Created by zhangrongjian on 14-1-23.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import <AVFoundation/AVFoundation.h>

@interface ExpressViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UIView *scanBackGroundView;

@property (strong, nonatomic) UIWebView *infoWeb;


@property (strong, readonly, nonatomic) RESideMenu *sideMenu;

//---------扫描条码有关------


@property (assign, nonatomic) int num;
@property (assign, nonatomic) BOOL upOrdown;
@property (strong, nonatomic) NSTimer * timer;

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@property (copy ,nonatomic) NSString * scanISBNStringValue;

//-------------------------
- (IBAction)CloseKeyBoard:(id)sender;
- (IBAction)ScanButton:(id)sender;
- (IBAction)SearchOk:(id)sender;

@end
