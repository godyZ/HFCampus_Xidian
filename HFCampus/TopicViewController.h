//
//  TopicViewController.h
//  HFCampus
//
//  Created by zhangrongjian on 14-1-25.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "ExtendView.h"

@interface TopicViewController : UIViewController<UISearchBarDelegate>
{
    
    BOOL isSearchActiveFM,isSearchActiveDM;
    
    //--- customozing---
    UIFont *headerLabelFont;
    UIColor *headerLabelColor;
    UIFont *selectedHeaderLabelFont;
    UIColor *selectedHeaderLabelColor;
    UIColor *headerBackGroundColor,*selectedHeaderBackGroundColor;
    UIColor *headerSeparatorColor;
}


@property(nonatomic,retain) NSMutableArray *allTopicArr;
@property(nonatomic,retain) NSMutableArray *filteredTopicArr;
@property(nonatomic,retain) UIScrollView *mainScrollView;
@property (nonatomic) UISearchBar* searchBarReagion;

@property(nonatomic,strong) UITableView *countryTbl;
@property (nonatomic, strong) ExtendView *extendView;
@property(nonatomic,strong) NSMutableArray *allCountryArr,*filteredCountryArr;
@property(nonatomic,strong) NSString *clickedCountryName;

//---set customozing---

-(void)setHeaderLabelFont:(UIFont *)font;
-(void)setHeaderLabelColor:(UIColor *)color;
-(void)setSelectedHeaderLabelFont:(UIFont *)font;
-(void)setSelectedHeaderLabelColor:(UIColor *)color;
-(void)setHeaderBackGroundColor:(UIColor *)color;
-(void)setSelectedHeaderBackGroundColor:(UIColor *)color;
-(void)setHeaderSeparatorColor:(UIColor *)color;

//---- 左侧划栏-----
@property (strong, readonly, nonatomic) RESideMenu *sideMenu;

@end
