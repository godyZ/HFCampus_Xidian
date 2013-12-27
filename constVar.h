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
#define CONETHEIGHT 64
#define NewsTVCOriginalY 64+30




#endif
