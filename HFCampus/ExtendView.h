//
//  ExtendView.h
//  HFCampus
//
//  Created by zhangrongjian on 14-1-29.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieView.h"
#import "TopicDataModel.h"

@interface ExtendView : UIView

@property (nonatomic, strong) PieView *pieView;
@property (nonatomic, strong) TopicDataModel *topicDataModel;

-(id)initWithFrame:(CGRect)frame DataModel:(TopicDataModel *)topicDataModel;

@end
