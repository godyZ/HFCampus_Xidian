//
//  STSortViewController.m
//  STBasic
//
//  Created by SunJiangting on 13-11-1.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STSortViewController.h"

#import "STSortOperation.h"
#import "STSortView.h"

#import "STCodeViewController.h"

@interface STSortViewController ()

@property (nonatomic, strong) STSortView * sortView;

@property (nonatomic, strong) NSOperationQueue * animationQueue;

@property (nonatomic, strong) NSMutableArray * sortMutableArray;

@end

@implementation STSortViewController


- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.animationQueue = [[NSOperationQueue alloc] init];
        self.animationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"源码" style:UIBarButtonItemStylePlain target:self action:@selector(viewSourceCode:)];
    

    STSortView * sortView = [[STSortView alloc] initWithFrame:CGRectMake(0, 100, 320, 300)];
    [sortView reloadSortDataSource:self.sortArray];
    [self.view addSubview:sortView];
    self.sortView = sortView;

    switch (self.arraySortType) {
       
        case STArraySortTypeBubbleSort:
            self.navigationItem.title = @"冒泡排序";
            break;
        case STArraySortTypeSelectSort:
            self.navigationItem.title = @"选择排序";
            break;
        case STArraySortTypeInsertSort:
            self.navigationItem.title = @"插入排序";
            break;
        case STArraySortTypeQuickSort:
            self.navigationItem.title = @"快速排序";
            break;
        default:
            break;
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.sortView reloadSortDataSource:self.sortArray];
    switch (self.arraySortType) {
        case STArraySortTypeBubbleSort:
            [self sortUsingBubbleTypeWithArray:self.sortArray];
            break;
        case STArraySortTypeSelectSort:
            [self sortUsingSelectTypeWithArray:self.sortMutableArray];
            break;
        case STArraySortTypeInsertSort:
            [self sortUsingInsertTypeWithArray:self.sortMutableArray];
            break;
        case STArraySortTypeQuickSort:
            [self sortUsingQuickTypeWithArray:self.sortMutableArray leftOffset:0 rightOffset:self.sortArray.count - 1];
            break;
        default:
            break;
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.animationQueue cancelAllOperations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                 duration:(NSTimeInterval)duration {
    
}

- (void) sortUsingInsertTypeWithArray:(NSMutableArray *) array {
    NSInteger count = array.count;
    for (int i = 1; i < count; i ++) {
        
        STSortOperation * operation1 = [[STSortOperation alloc] init];
        operation1.operationType = STSortOperationTypeMoveBaseline1;
        operation1.index1 = i;
        operation1.sortView = self.sortView;
        [self.animationQueue addOperation:operation1];
        
        id objI = [array objectAtIndex:i], objJ;
        int j = i;
        STSortOperation * operation2 = [[STSortOperation alloc] init];
        operation2.operationType = STSortOperationTypeMoveBaseline2;
        operation2.index2 = j;
        operation2.sortView = self.sortView;
        [self.animationQueue addOperation:operation2];
        
        
        STSortOperation * operation3 = [[STSortOperation alloc] init];
        operation3.operationType = STSortOperationTypeCacheUpElement;
        operation3.index1 = j;
        operation3.sortView = self.sortView;
        [self.animationQueue addOperation:operation3];
        
        while (j > 0 && [(objJ = [array objectAtIndex:j - 1]) intValue] > [objI intValue]) {

            [array replaceObjectAtIndex:j withObject:objJ];
            
            STSortOperation * operation4 = [[STSortOperation alloc] init];
            operation4.operationType = STSortOperationTypeMoveElement;
            operation4.index1 = j - 1;
            operation4.index2 = j;
            operation4.sortView = self.sortView;
            [self.animationQueue addOperation:operation4];
            
            j --;
            STSortOperation * operation5 = [[STSortOperation alloc] init];
            operation5.operationType = STSortOperationTypeMoveBaseline2;
            operation5.index2 = j;
            operation5.sortView = self.sortView;
            [self.animationQueue addOperation:operation5];
        }
        [array replaceObjectAtIndex:j withObject:objI];
        STSortOperation * operation6 = [[STSortOperation alloc] init];
        operation6.operationType = STSortOperationTypeCacheDownElement;
        operation6.sortView = self.sortView;
        [self.animationQueue addOperation:operation6];
    }
}

- (void) sortUsingSelectTypeWithArray:(NSMutableArray *) array {
    NSInteger count = array.count;
    for (int i = 0; i < count; i ++) {
        STSortOperation * operation1 = [[STSortOperation alloc] init];
        operation1.operationType = STSortOperationTypeMoveBaseline1;
        operation1.index1 = i;
        operation1.sortView = self.sortView;
        [self.animationQueue addOperation:operation1];
        
        for (int j = i; j < count; j ++) {
            STSortOperation * operation2 = [[STSortOperation alloc] init];
            operation2.operationType = STSortOperationTypeMoveBaseline2;
            operation2.index2 = j;
            operation2.sortView = self.sortView;
            [self.animationQueue addOperation:operation2];
            id objI = [array objectAtIndex:i];
            id objJ = [array objectAtIndex:j];
            if ([objI intValue] > [objJ intValue]) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
                STSortOperation * operation3 = [[STSortOperation alloc] init];
                operation3.operationType = STSortOperationTypeExchangeElement;
                operation3.index1 = i;
                operation3.index2 = j;
                operation3.sortView = self.sortView;
                [self.animationQueue addOperation:operation3];
            }
        }
    }
}

- (void) sortUsingQuickTypeWithArray:(NSMutableArray *) array
                          leftOffset:(NSInteger) left
                         rightOffset:(NSInteger) right {
    if (left < right) {
        
        id key = [array objectAtIndex:left];
        
        STSortOperation * operation0 = [[STSortOperation alloc] init];
        operation0.operationType = STSortOperationTypeCacheUpElement;
        operation0.index1 = left;
        operation0.sortView = self.sortView;
        [self.animationQueue addOperation:operation0];
        
        
        NSInteger low = left;
        NSInteger high = right;
        
        STSortOperation * operation1 = [[STSortOperation alloc] init];
        operation1.operationType = STSortOperationTypeMoveBaseline1;
        operation1.index1 = low;
        operation1.sortView = self.sortView;
        [self.animationQueue addOperation:operation1];
        
        STSortOperation * operation2 = [[STSortOperation alloc] init];
        operation2.operationType = STSortOperationTypeMoveBaseline2;
        operation2.index2 = high;
        operation2.sortView = self.sortView;
        [self.animationQueue addOperation:operation2];
        
        while (low < high) {
            while (low < high && [[array objectAtIndex:high] intValue] >= [key intValue]) {
                high --;                
                STSortOperation * operation3 = [[STSortOperation alloc] init];
                operation3.operationType = STSortOperationTypeMoveBaseline2;
                operation3.index2 = high;
                operation3.sortView = self.sortView;
                [self.animationQueue addOperation:operation3];
            }
            [array replaceObjectAtIndex:low withObject:[array objectAtIndex:high]];

            STSortOperation * operation5 = [[STSortOperation alloc] init];
            operation5.operationType = STSortOperationTypeMoveElement;
            operation5.index1 = high;
            operation5.index2 = low;
            operation5.sortView = self.sortView;
            [self.animationQueue addOperation:operation5];
        
            
            while (low < high && [[array objectAtIndex:low] intValue] <= [key intValue]) {
                low ++;
                STSortOperation * operation6 = [[STSortOperation alloc] init];
                operation6.operationType = STSortOperationTypeMoveBaseline1;
                operation6.index1 = low;
                operation6.sortView = self.sortView;
                [self.animationQueue addOperation:operation6];
            }
            [array replaceObjectAtIndex:high withObject:[array objectAtIndex:low]];

            STSortOperation * operation8 = [[STSortOperation alloc] init];
            operation8.operationType = STSortOperationTypeMoveElement;
            operation8.index1 = low;
            operation8.index2 = high;
            operation8.sortView = self.sortView;
            [self.animationQueue addOperation:operation8];
        }
        [array replaceObjectAtIndex:low withObject:key];
        STSortOperation * operation9 = [[STSortOperation alloc] init];
        operation9.operationType = STSortOperationTypeCacheDownElement;
        operation9.index1 = left;
        operation9.index2 = low;
        operation9.sortView = self.sortView;
        [self.animationQueue addOperation:operation9];
        
        [self sortUsingQuickTypeWithArray:array leftOffset:left rightOffset:low - 1];
        [self sortUsingQuickTypeWithArray:array leftOffset:low + 1 rightOffset:right];
    }
}

- (void) sortUsingBubbleTypeWithArray:(NSArray *) array {
    NSMutableArray * sortArray = [NSMutableArray arrayWithArray:array];
    BOOL exchanged = YES;
    NSInteger count = sortArray.count;
    for (int i = 0; i < count - 1 && exchanged; i ++) {
        exchanged = NO;
        STSortOperation * operation0 = [[STSortOperation alloc] init];
        operation0.operationType = STSortOperationTypeMoveBaseline1;
        operation0.index1 = i;
        operation0.sortView = self.sortView;
        [self.animationQueue addOperation:operation0];

        for (int j = 0; j < (count - 1 - i); j ++) {
            STSortOperation * operation1 = [[STSortOperation alloc] init];
            operation1.operationType = STSortOperationTypeMoveBaseline2;
            operation1.index2 = j;
            operation1.sortView = self.sortView;
            [self.animationQueue addOperation:operation1];
            
            id obj0 = [sortArray objectAtIndex:j];
            id obj1 = [sortArray objectAtIndex:j + 1];
            if ([obj0 intValue] > [obj1 intValue]) {
                exchanged = YES;
                /// 需要交换 obj0,obj1
                [sortArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                STSortOperation * operation3 = [[STSortOperation alloc] init];
                operation3.operationType = STSortOperationTypeExchangeElement;
                operation3.index1 = j;
                operation3.index2 = j + 1;
                operation3.sortView = self.sortView;
                [self.animationQueue addOperation:operation3];
            }
        }
    }
}


- (void) setSortArray:(NSArray *)sortArray {
    self.sortMutableArray = [NSMutableArray arrayWithArray:sortArray];
    _sortArray = sortArray;
}



- (void) viewSourceCode:(id) sender {
    STCodeViewController * viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"STCodeViewController"];
    viewController.algorithmType = self.arraySortType;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) logArray:(NSArray *) array {
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        printf("%d ", [obj intValue]);
    }];
    printf("\n");
}
@end
