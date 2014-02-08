//
//  PieView.h
//  HFCampus
//
//  Created by zhangrongjian on 14-1-29.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PieLayer, PieElement;

@interface PieView : UIView
@property (nonatomic, copy) void(^elemTapped)(PieElement*);
@end

@interface PieView (ex)
@property(nonatomic,readonly,retain) PieLayer *layer;
@end
