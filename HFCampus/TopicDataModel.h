//
//  TopicDataModel.h
//  HFCampus
//
//  Created by zhangrongjian on 14-1-26.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicItem : NSObject

@property (copy, nonatomic) NSString * topicOption;
@property (assign, nonatomic) float topicPercet;
@property (assign, nonatomic) int   topicBallots;

@end

@interface TopicDataModel : NSObject

@property (copy, nonatomic) NSString * topicTitle; //话题
@property (strong, nonatomic) NSMutableArray * topicItems;//选项 (TopicItem)

@end
