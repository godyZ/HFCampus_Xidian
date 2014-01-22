//
//  BookSearchHelper.h
//  hifcampus
//
//  Created by Hank on 13-2-15.
//  Copyright (c) 2013年 Hank. All rights reserved.
//

#import <Foundation/Foundation.h>

//-------各学校查询URL---
#define kbXidianURL         @"http://opac.lib.xidian.edu.cn"
#define kbXijiaotongURL     @"http://innopac.lib.xjtu.edu.cn"
#define kbXigongdaURL       @"http://202.117.255.187:8080/opac/"
#define kbShaanxiNormalURL  @"http://219.244.185.7:8991/F"
#define kbNorthwestURL      @"http://202.117.102.160/cgi-bin/"

#define kbDicKeyURL @"url"
#define kbDicKeyTitle @"title"
#define kbDicKeyTime @"time"
#define kbDicKeyInfo @"info"

@interface BookSearchHelper : NSObject

//总体思路, 图书列表显示, 通完处理html, 返回字典, 字典的每条数据有
//图书名称+作者, 出版社 + 时间, 基本借阅情况(可有可无), 详情URL

+(UIViewController *)viewcontrollerFromHtml:(NSString *)html;    //返回个ViewController
+(NSString *) bookInfoFromHtml:(NSString *)html;    //获取html
+(NSString *)bookHtmlFromKeyword:(NSString *)key withPage:(NSInteger)page;   //通过keyword,获取html
+(NSString *)bookHtmlFromISBN:(NSString *)key withPage:(NSInteger)page;  //通过ISBN,获取html
+(NSArray *)bookListFromHtml:(NSString *)urlContents;    //返回图书数组

/*
#pragma mark ------
#pragma mark 西电
+(NSString *)xidianBookHtmlFromKeyword:(NSString *)key withPage:(NSInteger)page; //获取西电关键字的html
+(NSArray *)xidianBookListFromHtml:(NSString *)urlContents;    //返回西电图书数组
+(NSString *)xidianBookInfoFromHtml:(NSString *)html;   //返回西电图书详情
+(NSString *)xidianBookInfoFromURL:(NSURL *)url;    //返回西电图书详情
*/

@end
