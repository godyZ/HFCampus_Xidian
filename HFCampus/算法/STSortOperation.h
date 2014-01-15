//
//  STSortOperation.h
//  STBasic
//
//  Created by SunJiangting on 13-11-2.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum STSortOperationType {
    STSortOperationTypeMoveBaseline1    = 1,
    STSortOperationTypeMoveBaseline2    = 2,
    STSortOperationTypeMoveElement      = 3,
    STSortOperationTypeCacheUpElement   = 4,
    STSortOperationTypeCacheDownElement = 5,
    STSortOperationTypeExchangeElement  = 6,
} STSortOperationType;

@class STSortView;
@interface STSortOperation : NSOperation

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSInteger index1;
@property (nonatomic, assign) NSInteger index2;
@property (nonatomic, weak)   STSortView  * sortView;
@property (nonatomic, assign) STSortOperationType operationType;

@end
