//
//  BookSearchViewController.h
//  HFCampus
//
//  Created by zhangrongjian on 14-1-18.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import <AVFoundation/AVFoundation.h>

@interface BookSearchViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *KeyOrISBNSegment;
@property (weak, nonatomic) IBOutlet UITextField *KeyOrISBNTextField;
@property (weak, nonatomic) IBOutlet UIButton *SearchButton;
@property (strong, readonly, nonatomic) RESideMenu *sideMenu;

//---------扫描条码有关------
@property (weak, nonatomic) IBOutlet UIButton *CodeBarButton;
@property (weak, nonatomic) IBOutlet UIView *scanBackGroundView;
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


- (IBAction)KeyOrISBNChanged:(id)sender;
- (IBAction)SearchButtonPress:(id)sender;
- (IBAction)CodeBarPress:(id)sender;


@end
