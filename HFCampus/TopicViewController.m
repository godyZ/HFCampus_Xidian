//
//  TopicViewController.m
//  HFCampus
//
//  Created by zhangrongjian on 14-1-25.
//  Copyright (c) 2014年 zgy. All rights reserved.
//

#define EACH_MODEL_HEIGHT 50.0

typedef enum _THBSState
{
    STATE_FULL_MENU,
    STATE_DETAILS_MENU
} THBSState;


#import "TopicViewController.h"
#import "AppDelegate.h"
#import "ControllerView.h"
#import "TopicDataModel.h"


@interface TopicViewController ()

@property (nonatomic,assign) THBSState state;

@end

CGRect fromPosition;

UIImageView *imview;
UILabel *label;
NSString *headerSearchedString;
NSDictionary *custDictinary;


@implementation TopicViewController


#pragma mark SearchBar Delegate

- (void) searchBarTextDidBeginEditing: (UISearchBar*) searchBar {

    [self.searchBarReagion setShowsCancelButton: YES animated: YES];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    //NSLog(@"self.state = %d",self.state);
    
    if (self.state == STATE_FULL_MENU) {
        
        headerSearchedString = searchText;
        isSearchActiveFM = TRUE;
        [self.filteredTopicArr removeAllObjects];
        for (NSString *s in self.allTopicArr) {
            
            NSRange result=[s rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(result.length>0) {
                
                //[self.filteredRegionArr addObject:s];
            }
        }
        
       // [self drawAllViewsOnScrollview:filteredRegionArr];    //绘制过滤后的选项
    }
    else if (self.state == STATE_DETAILS_MENU) {
        
        isSearchActiveDM = TRUE;
        [self.filteredCountryArr removeAllObjects];
        
        for (int i = 0; i < self.allCountryArr.count; i++) {
            NSDictionary *countryDictinary = [self.allCountryArr objectAtIndex:i];
            NSRange result=[[countryDictinary objectForKey:@"subheadingName"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(result.length>0) {
                
                [self.filteredCountryArr addObject:countryDictinary];
            }
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if (self.state == STATE_FULL_MENU) {
        self.mainScrollView.scrollEnabled = TRUE;
        
        [self.searchBarReagion resignFirstResponder];
        [self.searchBarReagion setShowsCancelButton: NO animated: YES];
    }
    else if (self.state == STATE_DETAILS_MENU) {
        
        [self.searchBarReagion resignFirstResponder];
        [self.searchBarReagion setShowsCancelButton: NO animated: YES];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
    if (self.state == STATE_FULL_MENU)
    {
        self.mainScrollView.scrollEnabled = TRUE;
        headerSearchedString = @"";
        
        isSearchActiveFM = FALSE;
        self.searchBarReagion.text = @"";
        [self.searchBarReagion setShowsCancelButton: NO animated: YES];
        [self.searchBarReagion resignFirstResponder];
    }
    else if (self.state == STATE_DETAILS_MENU) {
        
        isSearchActiveDM = FALSE;
        self.searchBarReagion.text = @"";
        [self.searchBarReagion setShowsCancelButton: NO animated: YES];
        [self.searchBarReagion resignFirstResponder];
        
    }
}

#pragma mark - Life Cycle MethodO

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //设置属性
    [self setHeaderLabelFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]];
    [self setHeaderLabelColor:colorPurpleTint];
    [self setHeaderBackGroundColor:[UIColor whiteColor]];
    [self setSelectedHeaderLabelFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    [self setSelectedHeaderLabelColor: colorPurpleTint];
    [self setSelectedHeaderBackGroundColor:[UIColor whiteColor]];
    [self setHeaderSeparatorColor:[UIColor lightGrayColor]];
    
    custDictinary = @{@"headerLabelFont": headerLabelFont,@"headerLabelColor": headerLabelColor,@"headerBackGroundColor": headerBackGroundColor,@"headerSeparatorColor": headerSeparatorColor};
    

    
    self.navigationController.navigationBar.barTintColor = colorNavBarTint;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,200,100)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:24];
    titleLabel.text = @" 话题";
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"general"] style:UIBarButtonItemStylePlain target:self action:@selector(showRightMenu)];
    
    
    headerSearchedString = @"";
    self.filteredTopicArr = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.searchBarReagion = [[UISearchBar alloc] initWithFrame:CGRectMake(0,64,320,44)];
    }
    else{
        
        self.searchBarReagion = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    }
    
    self.searchBarReagion.placeholder = @"Search";
    self.searchBarReagion.delegate = self;
    self.searchBarReagion.tintColor = [UIColor blueColor];
    
    CGFloat screenheight=[[UIScreen mainScreen]bounds].size.height;
    
    float sbMaxYPt = CGRectGetMaxY(self.searchBarReagion.frame);
    
    
    CGFloat scrollheight= screenheight - sbMaxYPt;
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,sbMaxYPt,320,scrollheight)];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.searchBarReagion];
    [self.view addSubview:self.mainScrollView];
    
    int offset = 0;
    if (!IS_WIDESCREEN) {
        offset = 350;
    }else{
        offset = 450;
    }
    
    self.remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, offset, 200, 100)];
    self.remainLabel.textColor = [UIColor lightGrayColor];
    self.remainLabel.text = @"投票模块仍在完善中^_^...";
    [self.view addSubview:self.remainLabel];
    
    [self addTestArrayData];
    
    [self drawAllViewsOnScrollview:self.allTopicArr];

}

- (void)addTestArrayData
{
    
    
    //TestData one
    TopicDataModel * testTopicOne = [[TopicDataModel alloc] init];
    testTopicOne.topicTitle = @"你对晓静校长的映像";
    testTopicOne.topicItems = [[NSMutableArray alloc] init];
    
    TopicItem *topicItem = [[TopicItem alloc] init];
    topicItem.topicOption = @"为新校长点赞";
    topicItem.topicPercet = 30;
    topicItem.topicBallots = 30;
    [testTopicOne.topicItems addObject:topicItem];
    
    topicItem = [[TopicItem alloc] init];
    topicItem.topicOption = @"还行，比前任好些";
    topicItem.topicPercet = 40;
    topicItem.topicBallots = 40;
    [testTopicOne.topicItems addObject:topicItem];
    
    topicItem = [[TopicItem alloc] init];
    topicItem.topicOption = @"并不是很了解";
    topicItem.topicPercet = 20;
    topicItem.topicBallots = 20;
    [testTopicOne.topicItems addObject:topicItem];
    
    topicItem = [[TopicItem alloc] init];
    topicItem.topicOption = @"感觉可以做的更好";
    topicItem.topicPercet = 10;
    topicItem.topicBallots = 10;
    
    [testTopicOne.topicItems addObject:topicItem];
    
    
    //TestData two
    TopicDataModel * testTopicTwo = [[TopicDataModel alloc]init];
    testTopicTwo.topicTitle = @"新综合楼周边卫生条件";

    //TestData Three
    TopicDataModel *testTopicThree = [[TopicDataModel alloc]init];
    testTopicThree.topicTitle = @"你喜欢西电么?";
    
    //TestData Four
    TopicDataModel *testTopicFour = [[TopicDataModel alloc]init];
    testTopicFour.topicTitle = @"西电男，你几个女朋友了?";
    
//    //TestData
    self.allTopicArr = [[NSMutableArray alloc] initWithObjects:testTopicOne, testTopicTwo, testTopicThree, testTopicFour, nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Customization Method

-(void)setHeaderLabelFont:(UIFont *)font{
    headerLabelFont = font;
}
-(void)setHeaderLabelColor:(UIColor *)color{
    headerLabelColor = color;
}
-(void)setHeaderBackGroundColor:(UIColor *)color{
    headerBackGroundColor = color;
}

-(void)setSelectedHeaderLabelFont:(UIFont *)font{
    selectedHeaderLabelFont = font;
}
-(void)setSelectedHeaderLabelColor:(UIColor *)color{
    selectedHeaderLabelColor = color;
}
-(void)setSelectedHeaderBackGroundColor:(UIColor *)color{
    selectedHeaderBackGroundColor = color;
}
-(void)setHeaderSeparatorColor:(UIColor *)color{
    headerSeparatorColor = color;
}




-(void)drawAllViewsOnScrollview :(NSArray *)drawArr    //绘制所有话题view
{
    [self.mainScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]; //先清除mainScrollView下面的subViews

    
    int yPos = 0;
    
    for (int i=0; i<drawArr.count; i++)
    {
        NSString *name = ((TopicDataModel *)[drawArr objectAtIndex:i]).topicTitle;
        
        
        ControllerView *contFullview = [[ControllerView alloc]initWithFrame:(CGRectMake(0, yPos, 320, EACH_MODEL_HEIGHT)) withTitle:name withCustomizationDict:custDictinary];
        if (i % 2 != 0) {
            contFullview.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
        }
        [self.mainScrollView addSubview:contFullview];
        
        [contFullview.optionBtn addTarget:self action:@selector(optionBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [contFullview.dummyBtn addTarget:self action:@selector(dummyBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        yPos += EACH_MODEL_HEIGHT;
    }
    
    float sizeOfContent = 0;
    UIView *lLast = [self.mainScrollView.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;
    sizeOfContent = wd+ht;
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, sizeOfContent);
}

#pragma mark
#pragma mark Expanding

-(IBAction)dummyBtnPressed:(id)sender
{
    self.remainLabel.hidden = YES;
    self.searchBarReagion.text = @"";                 //searchBar
    [self.searchBarReagion resignFirstResponder];
    [self.searchBarReagion setShowsCancelButton: NO animated: YES];
    
    //extend View
    
    fromPosition = [sender superview].frame;
    
    float mid_clicked = CGRectGetMidY([sender superview].frame);
    
    float scrollViewContentHeight = [(UIScrollView *)[[sender superview] superview] contentSize].height +50;
    
    CGFloat screenheight=[[UIScreen mainScreen]bounds].size.height;
    CGFloat tableheight= screenheight - (64+44+EACH_MODEL_HEIGHT);
    
    self.extendView=[[ExtendView alloc]initWithFrame:CGRectMake(0.0, CGRectGetMaxY(fromPosition), 320.0, screenheight) DataModel:[self.allTopicArr objectAtIndex:0]];  //extendView的高度使用screenHeight
    
    [self.mainScrollView addSubview:self.extendView];
    
    
    
    for (UIView* view in [[[sender superview] superview] subviews]) {
        
        float mid_view = CGRectGetMidY(view.frame);  //mid_view controllerView  , mid_clicked 所点击的位子
        
        if([view isKindOfClass:[ControllerView class]] && (mid_view < mid_clicked))
        {
            int diff_factor = (mid_clicked-mid_view)/EACH_MODEL_HEIGHT;
            
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowAnimatedContent animations:^{
                
                view.frame = CGRectMake(0, -50*diff_factor, 320, 50);
                
            } completion:^(BOOL finished)
            {
                self.state = STATE_DETAILS_MENU;
                
            }];
        }
        else if([view isKindOfClass:[ControllerView class]] && (mid_view == mid_clicked))  //所点击的controllerView
        {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowAnimatedContent animations:^{
                
                view.frame = CGRectMake(0, self.mainScrollView.contentOffset.y, 320, 50);
                self.extendView.frame = CGRectMake(0.0f, 50.0f, 320.0, tableheight);
                
               // view.backgroundColor = selectedHeaderBackGroundColor;
                
            } completion:^(BOOL finished) {
                self.state = STATE_DETAILS_MENU;
                self.mainScrollView.scrollEnabled = FALSE;
            }];
            
            //ControllerViewCell内部变化
            [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowAnimatedContent animations:^{
                
                //resize inside the view
                for (UIView* view in [[sender superview] subviews]) {
                    if([view isKindOfClass:[UILabel class]])        //标题
                    {
                        UILabel* label = (UILabel*)view;
                        if (label.tag == 1)
                        {
                            label.frame = CGRectMake(50, 5, 250, 35);
                            label.font = selectedHeaderLabelFont;
                            label.textColor = selectedHeaderLabelColor;
                        }
                        
                    }
                    else if([view isKindOfClass:[UIButton class]]){
                        
                        UIButton *button = (UIButton*)view;
                        
                        if (button.tag == 4) {             //option
                            
                            button.hidden = NO;
                        }
                        else if (button.tag == 6) {        //dummy
                            
                            button.userInteractionEnabled = NO;
                        }
                    }
                    else if([view isKindOfClass:[UIImageView class]]){
                        
                        UIImageView *imageView = (UIImageView*)view;
                        if (imageView.tag == 5) {
                            imageView.hidden = NO;
                            imageView.frame=CGRectMake(2, 5, 50, 40);
                        }
                    }
                }
                
            } completion:^(BOOL finished) {
                self.state = STATE_DETAILS_MENU;
                self.mainScrollView.scrollEnabled = FALSE;
    
            }];
        }
        else if([view isKindOfClass:[ControllerView class]] && (mid_view > mid_clicked))
        {
            
            int diff_factor = (mid_view-mid_clicked)/EACH_MODEL_HEIGHT;
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowAnimatedContent animations:^{
                
                view.frame = CGRectMake(0, scrollViewContentHeight+diff_factor*EACH_MODEL_HEIGHT, 320, 50);
                
            } completion:^(BOOL finished) {
                self.state = STATE_DETAILS_MENU;
            }];
        }
    }
    


}


-(IBAction)optionBtnPressed:(id)sender {
    
    self.remainLabel.hidden = NO;
    [self searchBarCancelButtonClicked:self.searchBarReagion];
    
    
    if (![headerSearchedString isEqualToString:@""])
    {
        self.searchBarReagion.text = headerSearchedString;
        [self.searchBarReagion becomeFirstResponder];
        [self.searchBarReagion setShowsCancelButton: YES animated: YES];
    }else
    {
        self.searchBarReagion.text = @"";
        headerSearchedString = @"";
    }
    
    self.mainScrollView.scrollEnabled = TRUE;
    
    int yPos = 0;
    
    for (UIView* view in [[[sender superview] superview] subviews]) {
        if([view isKindOfClass:[ControllerView class]])
        {
            
            [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowAnimatedContent animations:^{
                
                view.frame = CGRectMake(0, yPos, 320, 50);
                
                if (view == [sender superview]) {
                    
                   // view.backgroundColor = headerBackGroundColor;
                    
                    //resizeBack inside the view
                    for (UIView* subView in [view subviews]) {
                        
                        if([subView isKindOfClass:[UILabel class]])
                        {
                            
                            UILabel* label = (UILabel*)subView;
                            if (label.tag == 1) {
                                
                                label.frame = CGRectMake(20, 5, 280, 35);
                                label.textAlignment = NSTextAlignmentLeft;
                                label.font = headerLabelFont;
                                label.textColor = headerLabelColor;
                                
                            }
                            else if (label.tag == 2) {
                                
                                label.frame = CGRectMake(220, 10, 30, 30);
                                label.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
                                label.layer.cornerRadius = 15.0;
                            }
                        }
                        else if([subView isKindOfClass:[UIButton class]]){
                            
                            UIButton *button = (UIButton*)subView;
                            if (button.tag == 3) {
                                button.frame=CGRectMake(270, 12, 25, 25);
                                button.userInteractionEnabled = YES;
                            }
                            else if (button.tag == 4) {
                                
                                button.hidden = YES;
                            }
                            else if (button.tag == 6) {
                                
                                button.userInteractionEnabled = YES;
                            }
                        }
                        else if([subView isKindOfClass:[UIImageView class]]){
                            
                            UIImageView *imageView = (UIImageView*)subView;
                            if (imageView.tag == 5) {
                                
                                imageView.hidden = YES;
                            }
                            
                        }
                    }
                }
                
                
            } completion:^(BOOL finished) {
                self.state = STATE_FULL_MENU;
                self.title = @"Navigation Stack";
                self.searchBarReagion.placeholder = @"Search";
                
            }];
        }
        yPos += EACH_MODEL_HEIGHT;
        
    }
    
    [self.extendView removeFromSuperview];
}



#pragma mark - 显示左边栏

-(void)showLeftMenu
{
    
    
    
    if (!_sideMenu) {
        
        RESideMenuItem *newsItem = [[RESideMenuItem alloc] initWithTitle:@"资讯" image:[UIImage imageNamed:@"资讯"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                    {
                                        if (!HFcampusDelegate.globalNewsNavigationController) {
                                            HFcampusDelegate.globalNewsNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"newsNavigationController"];
                                        }
                                        [menu setRootViewController:HFcampusDelegate.globalNewsNavigationController];
                                    }];
        
        RESideMenuItem *personsItem = [[RESideMenuItem alloc] initWithTitle:@"人物" image:[UIImage imageNamed:@"人物"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                       {
                                           if (!HFcampusDelegate.globalPersonsNavigationController) {
                                               HFcampusDelegate.globalPersonsNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"personsNavigationController"];
                                           }
                                           [menu setRootViewController:HFcampusDelegate.globalPersonsNavigationController];
                                       }];
        RESideMenuItem *topicsItem = [[RESideMenuItem alloc] initWithTitle:@"投票" image:[UIImage imageNamed:@"投票"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                      {
                                          if (!HFcampusDelegate.globalTopicNavigationController)
                                          {
                                              HFcampusDelegate.globalTopicNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                                                                  instantiateViewControllerWithIdentifier:@"topicsNavigationController"];
                                          }
                                          [menu setRootViewController:HFcampusDelegate.globalTopicNavigationController];
                                      }];
        
        RESideMenuItem *algorithmsItem = [[RESideMenuItem alloc] initWithTitle:@"算法" image:[UIImage imageNamed:@"算法"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                          {
                                              if (!HFcampusDelegate.globalAlgorithmNavigationController){
                                                  HFcampusDelegate.globalAlgorithmNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AlgorithmNavigationController"];
                                              }
                                              [menu setRootViewController:HFcampusDelegate.globalAlgorithmNavigationController];
                                          }];
        
        RESideMenuItem *booksSearcher = [[RESideMenuItem alloc] initWithTitle:@"图书查询" image:[UIImage imageNamed:@"书籍查询"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                         {
                                             if (!HFcampusDelegate.globalBooksSearchNavigationController) {
                                                 HFcampusDelegate.globalBooksSearchNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BookSearchNavigationController"];
                                             }
                                             [menu setRootViewController:HFcampusDelegate.globalBooksSearchNavigationController];
                                         }];
        
        RESideMenuItem *expressSearcher = [[RESideMenuItem alloc] initWithTitle:@"快递查询" image:[UIImage imageNamed:@"快递查询"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                           {
                                               if (!HFcampusDelegate.globalExpressSearchNavigationController)
                                               {
                                                   HFcampusDelegate.globalExpressSearchNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpressSearchNavigationControllerID"];
                                               }
                                               [menu setRootViewController:HFcampusDelegate.globalExpressSearchNavigationController];
                                               
                                           }];
        RESideMenuItem *phonesSearcher = [[RESideMenuItem alloc] initWithTitle:@"电话查询" image:[UIImage imageNamed:@"电话查询"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                          {
                                              if (!HFcampusDelegate.globalPhoneSearchNavigationController) {
                                                  HFcampusDelegate.globalPhoneSearchNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PhoneSearchNavigationController"];
                                              }
                                              [menu setRootViewController:HFcampusDelegate.globalPhoneSearchNavigationController];
                                              
                                          }];
        
        RESideMenuItem *toolsItem = [[RESideMenuItem alloc] initWithTitle:@"工具" image:[UIImage imageNamed:@"工具"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                     {
                                         
                                     }];
        toolsItem.subItems  = @[booksSearcher, expressSearcher, phonesSearcher];
        
        RESideMenuItem *aboutItem = [[RESideMenuItem alloc] initWithTitle:@"关于" image:[UIImage imageNamed:@"关于"] highlightedImage:NULL action:^(RESideMenu *menu, RESideMenuItem *item)
                                     {
                                         if(!HFcampusDelegate.globalAboutUsNavigationController)
                                         {
                                             HFcampusDelegate.globalAboutUsNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUsNavigationControllerID"];
                                         }
                                         [menu setRootViewController:HFcampusDelegate.globalAboutUsNavigationController];
                                     }];
        
        _sideMenu = [[RESideMenu alloc] initWithItems:@[newsItem, personsItem, topicsItem,algorithmsItem, toolsItem,aboutItem]];
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 45: 76;
    }
    
    [_sideMenu show];
}

# pragma mark - 显示右边栏
-(void)showRightMenu
{
    
}

@end
