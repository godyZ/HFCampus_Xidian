//
//  MenuItem.h
//  hifcampus
//
//  Created by jackie on 13-10-16.
//  Copyright (c) 2013年 xidian. All rights reserved.
//

#import "JSONModel.h"

/* 
    campus_id: 10701,
    author: 10006,
    title: "西安电子科技大学附属小学悦美分校签约仪式举行",
    author_name: "西电新闻网",
    author_thumbnail: 11581,
    create_time: {
    $date: 1381937506000
    },
    _id: 46888,
    thumbnail: 14879
*/

@interface MenuItem : JSONModel

@property (strong, nonatomic) NSString *campusId;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *author_name;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) NSString *author_thumbnail;
@property (strong, nonatomic) NSDictionary *create_time;

/*
 title: "EBSD fundamentals and challenges in the investigation of semiconductor materials",
 start_time: {
 $date: 1382691600000
 },
 author: 102,
 author_name: "西电学术信息网",
 author_thumbnail: 0,
 person: "Gert Nolze博士",
 create_time: {
 $date: 1382407362986
 },
 place: "北校区西大楼三区四楼412会议室",
 _id: 18347,
 thumbnail: 3
 */
@property (strong, nonatomic) NSString *person;
@property (strong, nonatomic) NSDictionary *start_time;
@property (strong, nonatomic) NSString *place;
@end
