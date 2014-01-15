//
//  Header.h
//  HFCampus
//
//  Created by zhangrongjian on 13-12-26.
//  Copyright (c) 2013年 zgy. All rights reserved.
//

#ifndef HFCampus_Header_h
#define HFCampus_Header_h

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define HFcampusDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

//常用颜色表
#define colorNavBarTint [UIColor colorWithRed:219.0f/255.0f green:112.0f/255.0f blue:147.0f/255.0f alpha:1.0f]
//#define colorNavBarTint [UIColor colorWithRed:0.97f green:0.37f blue:0.38f alpha:1.0f]
//#define colorNavBarTint [UIColor colorWithRed:.927f green:.264f blue:.03f alpha:1]
#define colorChinaRed   [UIColor colorWithRed:206.0/255.0 green:16.0/255.0 blue:37.0/255.0 alpha:1.0f]

//高度表
#define CONETHEIGHT 64
#define NewsTVCOriginalY 64+30
#define TopLineCellHeight 195
#define NewsLineCellHeight 70
#define LoadMoreCellHeight 40

//网络id
#define CAMPUS_ID @"10701"
#define kHiMainURL @"http://58.215.177.233:8000"

#define UMENG_APPKEY  @"512f4ff4527015753300000c"
#define PLAYDATA_APPKEY @"d0b879d816eb351b"

#define BAIDU_APPKEY  @"9027ac2585273e77ad917850cc6c332b"

#define HICAMPOUS_URL @"58.215.177.233:8000/mobile"

#define LOGIN_URL @"login/"
#define REGISTER_URL @"register/"
#define USER_INFO @"user_info"

//本地存储文件
#define kHiSaveNews @"news.dat"
#define kHiSavePerson @"person.dat"
#define kHiSaveAct @"act.dat"





#endif
