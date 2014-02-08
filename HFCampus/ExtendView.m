//
//  ExtendView.m
//  HFCampus
//
//  Created by zhangrongjian on 14-1-29.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import "ExtendView.h"
#import "MagicPieLayer.h"
#import "NSMutableArray+pieEx.h"

#define LOG_ACTION


@implementation ExtendView

- (id)initWithFrame:(CGRect)frame DataModel:(TopicDataModel *)topicDataModel
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pieView = [[PieView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height - 100)];
        
        [self.pieView setBackgroundColor:[UIColor whiteColor]];
        
        self.topicDataModel = topicDataModel;
        
        PieElement* newElem1 = [PieElement pieElementWithValue:((TopicItem *)[topicDataModel.topicItems objectAtIndex:0]).topicBallots color:itemOneColor];
        int insertIndex = arc4random() % (self.pieView.layer.values.count + 1);
        [self.pieView.layer insertValues:@[newElem1] atIndexes:@[@(0)] animated:YES];
        
        PieElement* newElem2 = [PieElement pieElementWithValue:((TopicItem *)[topicDataModel.topicItems objectAtIndex:1]).topicBallots color:itemTwoColor];
        insertIndex = arc4random() % (self.pieView.layer.values.count + 1);
        [self.pieView.layer insertValues:@[newElem2] atIndexes:@[@(1)] animated:YES];
        
        PieElement* newElem3 = [PieElement pieElementWithValue:((TopicItem *)[topicDataModel.topicItems objectAtIndex:2]).topicBallots color:itemThreeColor];
        insertIndex = arc4random() % (self.pieView.layer.values.count + 1);
        [self.pieView.layer insertValues:@[newElem3] atIndexes:@[@(2)] animated:YES];
        
        PieElement* newElem4 = [PieElement pieElementWithValue:((TopicItem *)[topicDataModel.topicItems objectAtIndex:3]).topicBallots color:itemFourColor];
        insertIndex = arc4random() % (self.pieView.layer.values.count + 1);
        [self.pieView.layer insertValues:@[newElem4] atIndexes:@[@(3)] animated:YES];
        
        
        self.pieView.layer.transformTitleBlock = ^(PieElement* elem){
            return [[NSString alloc] initWithFormat:@"%d票",(int)elem.val];
        };
        self.pieView.layer.showTitles = ShowTitlesAlways;
        
        UIButton *optionOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        optionOne.frame = CGRectMake(20.0f, frame.size.height - 260, 130.0f, 25.0f);
        [optionOne setTitle:((TopicItem *)[topicDataModel.topicItems objectAtIndex:0]).topicOption forState:UIControlStateNormal];
        [optionOne setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        [optionOne.layer setMasksToBounds:YES];
        [optionOne.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        optionOne.backgroundColor = itemOneColor;
        [optionOne addTarget:self action:@selector(OptionOneClick:) forControlEvents:UIControlEventTouchUpInside];

        UIButton *optionTwo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        optionTwo.frame = CGRectMake(180.0f, frame.size.height - 260, 130.0f, 25.0f);
        [optionTwo setTitle:((TopicItem *)[topicDataModel.topicItems objectAtIndex:1]).topicOption forState:UIControlStateNormal];
        [optionTwo setTitle:((TopicItem *)[topicDataModel.topicItems objectAtIndex:1]).topicOption forState:UIControlStateHighlighted];
        [optionTwo setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        [optionTwo.layer setMasksToBounds:YES];
        [optionTwo.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        optionTwo.backgroundColor = itemTwoColor;
        [optionTwo addTarget:self action:@selector(OptionTwoClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *optionThree = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        optionThree.frame = CGRectMake(20.0f, frame.size.height - 220, 130.0f, 25.0f);
        [optionThree setTitle:((TopicItem *)[topicDataModel.topicItems objectAtIndex:2]).topicOption forState:UIControlStateNormal];
        [optionThree setTitle:((TopicItem *)[topicDataModel.topicItems objectAtIndex:2]).topicOption forState:UIControlStateHighlighted];
        [optionThree setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        [optionThree.layer setMasksToBounds:YES];
        [optionThree.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        optionThree.backgroundColor = itemThreeColor;
        [optionThree addTarget:self action:@selector(OptionThreeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *optionFour = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        optionFour.frame = CGRectMake(180.0f, frame.size.height - 220, 130.0f, 25.0f);
        [optionFour setTitle:((TopicItem *)[topicDataModel.topicItems objectAtIndex:3]).topicOption forState:UIControlStateNormal];
        [optionFour setTitle:((TopicItem *)[topicDataModel.topicItems objectAtIndex:3]).topicOption forState:UIControlStateHighlighted];
        [optionFour setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        [optionFour.layer setMasksToBounds:YES];
        [optionFour.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        optionFour.backgroundColor = itemFourColor;
        [optionFour addTarget:self action:@selector(OptionFourClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *touPiao = [[UILabel alloc] initWithFrame:CGRectMake(135.0f, frame.size.height - 190, 60.0f, 25.0f)];
        touPiao.text = @"请投票";
        touPiao.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
        touPiao.textColor = [UIColor lightGrayColor];
        touPiao.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.pieView];
        [self addSubview:optionOne];
        [self addSubview:optionTwo];
        [self addSubview:optionThree];
        [self addSubview:optionFour];
        [self addSubview:touPiao];
    }
    return self;
}

- (void)OptionOneClick:(id)sender
{
    ((TopicItem *)[self.topicDataModel.topicItems objectAtIndex:0]).topicBallots ++;
    [PieElement animateChanges:^{
        PieElement *elem = [self.pieView.layer.values objectAtIndex:0];
        elem.val = ((TopicItem *)[self.topicDataModel.topicItems objectAtIndex:0]).topicBallots;
    }];
}
- (void)OptionTwoClick:(id)sender
{
    ((TopicItem *)[self.topicDataModel.topicItems objectAtIndex:1]).topicBallots ++;
    [PieElement animateChanges:^{
        PieElement *elem = [self.pieView.layer.values objectAtIndex:1];
        elem.val = ((TopicItem *)[self.topicDataModel.topicItems objectAtIndex:1]).topicBallots;
    }];
}
- (void)OptionThreeClick:(id)sender
{
    ((TopicItem *)[self.topicDataModel.topicItems objectAtIndex:2]).topicBallots ++;
    [PieElement animateChanges:^{
        PieElement *elem = [self.pieView.layer.values objectAtIndex:2];
        elem.val = ((TopicItem *)[self.topicDataModel.topicItems objectAtIndex:2]).topicBallots;
    }];
}
- (void)OptionFourClick:(id)sender
{
    ((TopicItem *)[self.topicDataModel.topicItems objectAtIndex:3]).topicBallots ++;
    [PieElement animateChanges:^{
        PieElement *elem = [self.pieView.layer.values objectAtIndex:3];
        elem.val = ((TopicItem *)[self.topicDataModel.topicItems objectAtIndex:3]).topicBallots;
    }];
}

- (UIColor*)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (IBAction)animateChangeVal:(id)sender
{
    if(self.pieView.layer.values.count == 0)return;
    double randCount = MAX(MIN(self.pieView.layer.values.count, 2), arc4random() % self.pieView.layer.values.count);
    NSMutableArray* randIndexes = [NSMutableArray new];
    NSMutableArray* changeValArr = [NSMutableArray new];
    [PieElement animateChanges:^{
        for(int i = 0; i < randCount; i++){
            int randIndx = arc4random() % self.pieView.layer.values.count;
            while ([randIndexes containsObject:@(randIndx)]) {
                randIndx = arc4random() % self.pieView.layer.values.count;
            }
            [randIndexes addObject:@(randIndx)];
            int randVal = (5 + arc4random() % 10);
            int prevVal = [(PieElement*)self.pieView.layer.values[randIndx] val];
            [self.pieView.layer.values[randIndx] setVal:randVal];
            [changeValArr addObject:[NSString stringWithFormat:@"%d -> %d", prevVal, randVal]];
        }
    }];
#ifdef LOG_ACTION
    NSMutableString* logStr = [[NSMutableString alloc] initWithString:@"Update elements:\n"];
    for(int i = 0; i < randIndexes.count; i++){
        [logStr appendFormat:@"%@ element: %@\n", randIndexes[i], changeValArr[i]];
    }
    NSLog(@"%@", logStr);
#endif
}

- (IBAction)addPressed:(id)sender
{
    PieElement* newElem = [PieElement pieElementWithValue:(5 + arc4random() % 10) color:[self randomColor]];
    //    newElem.showTitle = YES;
    int insertIndex = arc4random() % (self.pieView.layer.values.count + 1);
    [self.pieView.layer insertValues:@[newElem] atIndexes:@[@(insertIndex)] animated:YES];
#ifdef LOG_ACTION
    NSLog(@"Insert values %@ to indixes %@", [self arrDesc:@[newElem]], [self arrDesc:@[@(insertIndex)]]);
#endif
}

- (IBAction)deletePressed:(id)sender
{
    if(self.pieView.layer.values.count <= 0)
        return;
    
    int deleteIndex = arc4random() % self.pieView.layer.values.count;
    [self.pieView.layer deleteValues:@[self.pieView.layer.values[deleteIndex]] animated:YES];
#ifdef LOG_ACTION
    NSLog(@"Delete values at indixes %@", [self arrDesc:@[@(deleteIndex)]]);
#endif
}

- (IBAction)refreshData:(id)sender
{
    [self.pieView.layer setNeedsDisplay];
}

- (IBAction)performRandomActions:(id)sender
{
    while (arc4random() % 100 < 90) {
        switch (arc4random() % 3) {
            case 0:
                [self addPressed:nil];
                break;
            case 1:
                [self deletePressed:nil];
                break;
            case 2:
                [self animateChangeVal:nil];
                break;
                
                
            default:
                break;
        }
    }
}

- (IBAction)animateStartEnd
{
    float startAngle = arc4random() % 360;
    float endAngle = arc4random() % 300 + 60 + startAngle;
    [self.pieView.layer setStartAngle:startAngle endAngle:endAngle animated:YES];
}

- (NSString*)arrDesc:(NSArray*)arr
{
    NSString* str = arr.description;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return str;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
