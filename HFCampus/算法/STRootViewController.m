//
//  STRootViewController.m
//  STBasic
//
//  Created by SunJiangting on 13-11-2.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STRootViewController.h"
#import "STSortViewController.h"
#import "STHanoiViewController.h"
#import "AppDelegate.h"

@interface STRootViewController ()

@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSArray * sortArray;
@property (nonatomic, strong) UILabel * numberOfHanoiDiskLabel;
@property (nonatomic, assign) NSInteger numberOfDisks;

@end

@implementation STRootViewController

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray * array = @[@(20),@(6),@(2),@(8),@(9),@(12), @(2), @(4), @(3), @(4), @(7), @(11)];
        self.sortArray = array;
        
        NSMutableArray * dataSource = [NSMutableArray arrayWithCapacity:2];
        
        NSMutableArray * section0 = [NSMutableArray arrayWithCapacity:2];
        [section0 addObject:@{@"type":@(STArraySortTypeBubbleSort), @"title":@"冒泡排序"}];
        [section0 addObject:@{@"type":@(STArraySortTypeSelectSort), @"title":@"选择排序"}];
        [section0 addObject:@{@"type":@(STArraySortTypeInsertSort), @"title":@"插入排序"}];
        [section0 addObject:@{@"type":@(STArraySortTypeQuickSort), @"title":@"快速排序"}];
        NSString * section0Title = [NSString stringWithFormat:@"几种常用的排序算法, 排序数据源\n%@", [self.sortArray componentsJoinedByString:@","]];
        NSDictionary * section0Dict = @{@"sectionHeaderTitle":section0Title, @"section":section0};
        [dataSource addObject:section0Dict];
        
        NSMutableArray * section1 = [NSMutableArray arrayWithCapacity:2];
        [section1 addObject:@{@"type":@(STArraySortTypeBubbleSort), @"title":@"汉诺塔算法"}];
        NSString * section1Title = [NSString stringWithFormat:@"经典的几种递归算法\n"];
        NSDictionary * section1Dict = @{@"sectionHeaderTitle":section1Title, @"section":section1};
        [dataSource addObject:section1Dict];
        
        self.dataSource = dataSource;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    //-------------navigationBar------------------
    self.navigationController.navigationBar.barTintColor = colorNavBarTint;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,200,100)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:23];
    titleLabel.text = @"算法演示";
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Set"] style:UIBarButtonItemStylePlain target:self action:@selector(showRightMenu)];
    //---------------------------------------------
    
    
    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"速度比例";
    label.textColor = [UIColor blackColor];
    [tableHeaderView addSubview:label];
    
    id speed = [[NSUserDefaults standardUserDefaults] valueForKey:@"STMoveAnimationDuration"];
    if (!speed) {
        speed = @(0.5);
        [[NSUserDefaults standardUserDefaults] setValue:speed forKey:@"STMoveAnimationDuration"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(100, 10, 200, 30)];
    [tableHeaderView addSubview:slider];
    slider.minimumValue = 0.2;
    slider.maximumValue = 1.2;
    slider.value = [speed floatValue];
    slider.continuous = NO;
    slider.minimumTrackTintColor = [UIColor blueColor];
    [slider addTarget:self action:@selector(speedChanged:) forControlEvents:UIControlEventValueChanged];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 80, 30)];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.text = @"汉诺塔数";
    label2.textColor = [UIColor blackColor];
    [tableHeaderView addSubview:label2];
    
    id disks = [[NSUserDefaults standardUserDefaults] valueForKey:@"STNumberOfHanoiDisks"];
    if (!disks) {
        disks = @(4);
    }
    
    self.numberOfHanoiDiskLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 50, 30)];
    self.numberOfHanoiDiskLabel.textAlignment = NSTextAlignmentLeft;
    [self updateNumberOfDisks:[disks intValue]];
    self.numberOfHanoiDiskLabel.textColor = [UIColor blackColor];
    [tableHeaderView addSubview:self.numberOfHanoiDiskLabel];
    
    UIStepper * stepper = [[UIStepper alloc] initWithFrame:CGRectMake(150, 50, 200, 30)];
    stepper.minimumValue = 3;
    stepper.maximumValue = 10;
    stepper.tintColor = [UIColor blueColor];
    stepper.value = [disks intValue];
    [stepper addTarget:self action:@selector(numberOfDiskChanged:) forControlEvents:UIControlEventValueChanged];
    [tableHeaderView addSubview:stepper];
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) speedChanged:(UISlider *) slider {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@(slider.value) forKey:@"STMoveAnimationDuration"];
    [userDefault synchronize];
}

- (void) updateNumberOfDisks:(NSInteger) numberOfDisks {
    self.numberOfDisks = numberOfDisks;
    self.numberOfHanoiDiskLabel.text = [NSString stringWithFormat:@"%ld", numberOfDisks];
    [[NSUserDefaults standardUserDefaults] setValue:@(numberOfDisks) forKey:@"STNumberOfHanoiDisks"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) numberOfDiskChanged:(UIStepper *) sender {
    [self updateNumberOfDisks:sender.value];
}

#pragma mark - Table view data source

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary * sectionInfo = [self.dataSource objectAtIndex:section];
    return [sectionInfo valueForKey:@"sectionHeaderTitle"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   // Return the number of sections.
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSDictionary * sectionInfo = [self.dataSource objectAtIndex:section];
    return [[sectionInfo valueForKey:@"section"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    // Configure the cell...
    NSDictionary * sectionInfo = [self.dataSource objectAtIndex:indexPath.section];
    NSArray * rowInfo = [[sectionInfo valueForKey:@"section"] objectAtIndex:indexPath.row];
    tableViewCell.textLabel.text = [rowInfo valueForKey:@"title"];
    return tableViewCell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * sectionInfo = [self.dataSource objectAtIndex:indexPath.section];
    NSArray * rowInfo = [[sectionInfo valueForKey:@"section"] objectAtIndex:indexPath.row];
    if (indexPath.section == 0) {
        STSortViewController * viewController = (STSortViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"STSortViewController"];
        viewController.sortArray = self.sortArray;
        viewController.arraySortType = [[rowInfo valueForKey:@"type"] intValue];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            STHanoiViewController * viewController = (STHanoiViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"STHanoiViewController"];
            viewController.numberOfHanois = self.numberOfDisks;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}
#pragma mark - 显示左边栏
-(void)showLeftMenu
{
    //    __block UINavigationController *tempNavigationController = NULL;
    
    if (!_sideMenu) {
        RESideMenuItem *newsItem = [[RESideMenuItem alloc] initWithTitle:@"新闻" action:^(RESideMenu *menu, RESideMenuItem *item) {
            if (!HFcampusDelegate.globalNewsNavigationController) {
                HFcampusDelegate.globalNewsNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"newsNavigationController"];
            }
            [menu setRootViewController:HFcampusDelegate.globalNewsNavigationController];
        }];
        RESideMenuItem *personsItem = [[RESideMenuItem alloc] initWithTitle:@"人物" action:^(RESideMenu *menu, RESideMenuItem *item) {
            if (!HFcampusDelegate.globalPersonsNavigationController) {
                HFcampusDelegate.globalPersonsNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"personsNavigationController"];
            }
            [menu setRootViewController:HFcampusDelegate.globalPersonsNavigationController];
        }];
        RESideMenuItem *topicsItem = [[RESideMenuItem alloc] initWithTitle:@"话题" action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            
        }];
        RESideMenuItem *picturesItem = [[RESideMenuItem alloc] initWithTitle:@"图说" action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            NSLog(@"Item %@", item);
        }];
        RESideMenuItem *algorithmsItem = [[RESideMenuItem alloc] initWithTitle:@"算法" action:^(RESideMenu *menu, RESideMenuItem *item) {
            [menu hide];
            if (!HFcampusDelegate.globalAlgorithmNavigationController){
                HFcampusDelegate.globalAlgorithmNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AlgorithmNavigationController"];
            }
            [menu setRootViewController:HFcampusDelegate.globalAlgorithmNavigationController];
        }];
        
        RESideMenuItem *booksSearcher = [[RESideMenuItem alloc] initWithTitle:@"图书查询" action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            [menu hide];
        }];
        
        RESideMenuItem *expressSearcher = [[RESideMenuItem alloc] initWithTitle:@"快递查询" action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            [menu hide];
        }];
        RESideMenuItem *phonesSearcher = [[RESideMenuItem alloc] initWithTitle:@"电话查询" action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
            [menu hide];
        }];
        
        RESideMenuItem *toolsItem = [[RESideMenuItem alloc] initWithTitle:@"工具" action:^(RESideMenu *menu, RESideMenuItem *item) {
            NSLog(@"Item %@", item);
        }];
        toolsItem.subItems  = @[booksSearcher, expressSearcher, phonesSearcher];
        
        RESideMenuItem *aboutItem = [[RESideMenuItem alloc] initWithTitle:@"关于" action:^(RESideMenu *menu, RESideMenuItem *item) {
            
        }];
        
        _sideMenu = [[RESideMenu alloc] initWithItems:@[newsItem, personsItem, topicsItem, picturesItem,algorithmsItem, toolsItem,aboutItem]];
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 45: 76;
    }
    
    [_sideMenu show];
}

#pragma mark - 显示右边栏
-(void)showRightMenu
{
    
}

@end
