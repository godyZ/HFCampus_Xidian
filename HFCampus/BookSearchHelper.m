//
//  BookSearchHelper.m
//  hifcampus
//
//  Created by Hank on 13-2-15.
//  Copyright (c) 2013年 Hank. All rights reserved.
//

#import "BookSearchHelper.h"

#import "HiHelper.h"
//#import "HiUserHelper.h"

@implementation BookSearchHelper

//总体思路, 图书列表显示, 通完处理html, 返回字典, 字典的每条数据有
//图书名称+作者, 出版社 + 时间, 基本借阅情况(可有可无), 详情URL

+(UIViewController *)viewcontrollerFromHtml:(NSString *)html    //返回个ViewController
{
    UIViewController *contentVC = [[UIViewController alloc] init];
    
    UIWebView *webView = [[UIWebView alloc] init];
    [webView loadHTMLString:html baseURL:nil];
    contentVC.view = webView;
    
    return contentVC;
}

+(NSString *) bookInfoFromHtml:(NSString *)html     //获取html
{
    switch (1) {//[HiUserHelper getUserSchool]) {   //改成1了. 现在只支持一个学校了.
        case 1:         //西安电子科技大学
            return [self xidianBookInfoFromHtml:html];
            break;
        
        case 2:         //西安交通大学
            return [self xijiaotongBookInfoFromHtml:html];
            break;
            
        case 3:         //西北工业大学
            return [self xigongdaBookInfoFromHtml:html];
            break;
            
        case 4:         //陕西师范大学
            return [self shaanxiNormalBookInfoFromHtml:html];
            break;
            
        default:
            return @"这个学样暂时不可用啊!!!";
            break;
    }
}

+(NSString *)bookHtmlFromKeyword:(NSString *)key withPage:(NSInteger)page   //通过Keyword,获取html
{
    switch (1) {//[HiUserHelper getUserSchool]) {   //改成1了. 现在只支持一个学校了.
        case 1:         //西安电子科技大学
            return [self xidianBookHtmlFromKeyword:key withPage:page];
            break;
            
        case 2:         //西安交通大学
            return [self xijiaotongBookHtmlFromKeyword:key withPage:page];
            break;
            
        case 3:         //西北工业大学
            return [self xigongdaBookHtmlFromKeyword:key withPage:page];
            break;
            
        case 4:         //陕西师范大学
            return [self shaanxiNormalBookHtmlFromKeyword:key withPage:page];
            break;
            
        default:
            return @"这个学样暂时不可用啊!!!";
            break;
    }
}

+(NSString *)bookHtmlFromISBN:(NSString *)key withPage:(NSInteger)page   //通过ISBN,获取html
{
    switch (1) {//[HiUserHelper getUserSchool]) {   //改成1了. 现在只支持一个学校了.
        case 1:         //西安电子科技大学
            return [self xidianBookHtmlFromISBN:key withPage:page];
            break;
            
        case 2:         //西安交通大学
            return [self xijiaotongBookHtmlFromISBN:key withPage:page];
            break;
            
        case 3:         //西北工业大学
            return [self xigongdaBookHtmlFromISBN:key withPage:page];
            break;
            
        case 4:         //陕西师范大学
            return [self shaanxiNormalBookHtmlFromISBN:key withPage:page];
            break;
            
        default:
            return @"这个学样暂时不可用啊!!!";
            break;
    }
}

+(NSArray *)bookListFromHtml:(NSString *)urlContents    //返回图书数组
{
    switch (1) {//[HiUserHelper getUserSchool]) {   //改成1了. 现在只支持一个学校了.
        case 1:         //西安电子科技大学
            return [self xidianBookListFromHtml:urlContents];
            break;
            
        case 2:         //西安交通大学
            return [self xijiaotongBookListFromHtml:urlContents];
            break;
            
        case 3:         //西北工业大学
            return [self xigongdaBookListFromHtml:urlContents];
            break;
            
        case 4:         //陕西师范大学
            return [self shaanxiNormalBookListFromHtml:urlContents];
            break;
            
        default:
            return nil;
            break;
    }
}

#pragma mark ------
#pragma mark 功能函数
+(NSString *)delStringWithString:(NSString *)string withRegex:(NSString*) regex
//删除string中符合 regex的正则
{
    NSString *rStr = string.copy;
    
    NSArray *delArray = [HiHelper arrayFromString:string withRegular:regex];
    for (int i = 0; i < delArray.count; ++i) {
        rStr = [rStr stringByReplacingOccurrencesOfString:[delArray objectAtIndex:i] withString:@""];
    }
    return rStr;
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr {   //工大用的转码的.
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"&#x"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    tempStr3 = [tempStr3 stringByReplacingOccurrencesOfString:@";" withString:@""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* returnStr = [NSPropertyListSerialization  propertyListFromData:tempData
                                                            mutabilityOption:NSPropertyListImmutable
                                                                      format:NULL
                                                            errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
}

/*
 + (void) testUTF8{
 //  utf-8转码测试
 NSString* utf8Temp = @"&#x5317;&#x4eac;&#x4eba;&#x6c11;&#x90ae;&#x7535;&#x51fa;&#x7248;&#x793e;&#x0032;&#x0030;&#x0031;&#x0033;";
 NSLog(@"%@",utf8Temp);
 
 //  1.
 //    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
 //    utf8Temp = [utf8Temp stringByReplacingPercentEscapesUsingEncoding:enc];
 //    NSLog(@"%@",utf8Temp);
 
 //  2.
 utf8Temp = [utf8Temp stringByReplacingOccurrencesOfString:@"&#" withString:@"0"];
 NSArray *arr = [utf8Temp componentsSeparatedByString:@";"];
 for(NSString *v in arr){
 NSScanner *scanner;
 unsigned int result;
 scanner = [NSScanner scannerWithString:v];
 [scanner scanHexInt: &result];
 NSLog(@"%@",[NSString stringWithFormat:@"%C",result]);
 }
 
 //    NSString* temp = @"我们";
 //    temp = [temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 //    NSLog(@"%@",temp);  //  %E6%88%91
 //    temp = [temp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 //    NSLog(@"%@",temp);  //  我
 }
 */


//以下是学校
#pragma mark ------
#pragma mark 西电
+(NSString *)xidianBookHtmlFromKeyword:(NSString *)key withPage:(NSInteger)page //获取西电关键字的html
{
    /*
     String params="/search~/a?" + "searchtype=t"+ "&searcharg="
     + keyWord+ "&SORT=D";
     */
    
    //
    //请求数据
    NSString *urlStr = [NSString stringWithFormat:@"%@/search~/a?searchtype=t&searcharg=%@", kbXidianURL, key];
    NSLog(@"%@", urlStr);
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSError *err = nil;
    NSString *urlContents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    
    if(urlContents.length <= 0)
    {
        NSLog(@"err %@",err);
        return nil;
        
    }
    return urlContents;
}

+(NSString *)xidianBookHtmlFromISBN:(NSString *)key withPage:(NSInteger)page //获取西电关键字的html
{
    //
    //请求数据
    NSString *urlStr = [NSString stringWithFormat:@"%@/search~/a?searchtype=i&searcharg=%@", kbXidianURL, key];
    NSLog(@"%@", urlStr);
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSError *err = nil;
    NSString *urlContents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    
    if(urlContents.length <= 0)
    {
        NSLog(@"err %@",err);
        return nil;
        
    }
    return urlContents;
}

+(NSArray *)xidianBookListFromHtml:(NSString *)urlContents    //返回西电图书数组
{
    if (urlContents == nil) {
        return nil;
    }
    //NSLog(@"urlContents %@", urlContents);
    NSString *regexTag = @"(?<=<tr  class=\"browseEntry\">)(.|\n)*?(?=</tr>)";
    NSArray *trArray = [HiHelper arrayFromString:urlContents withRegular:regexTag];
    NSMutableArray *resultArray = [[NSMutableArray alloc]initWithCapacity:trArray.count];
    
    for (int i = 0; i<trArray.count; ++i)
    {
        //详情URL
        NSString *urlRegex = @"(?<=<a href=\").*(?=\">)";
        NSString *urlStr = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:urlRegex];
        urlStr = [NSString stringWithFormat:@"%@%@",kbXidianURL, urlStr];   //加上个根URL
        
        //标题
        NSString *titleRegex = @"(?<=\">).*(?=</a>)";
        NSString *titleStr = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:titleRegex];
        NSString *title2Regex = @"(?<=</a>  )/(.|\n)*?(?=</td>)";
        NSString *title2Str = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:title2Regex];
        titleStr = [titleStr stringByAppendingString:title2Str];
        //删除空格, 删除换行
        titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//去掉换行
        titleStr = [titleStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];//去掉空格
        
        //出版时间
        NSString *timeRegex = @"(?<=class=\"browseEntryYear\">)(.|\n)*?(?=</td>)";
        NSString *timeStr = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:timeRegex];
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//去掉换行
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];//去掉换行
        
        //NSLog(@"%@\n%@\n%@", urlStr, titleStr, timeStr);
        
        //生成字典
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:urlStr, kbDicKeyURL,
                                titleStr, kbDicKeyTitle,
                                timeStr, kbDicKeyTime,                                                                    nil];
        [resultArray addObject:dic];
    }
    
    
    NSLog(@"result array :%@", resultArray);
    
    return resultArray;
}

+(NSString *)xidianBookInfoFromHtml:(NSString *)html   //返回西电图书详情
{
    NSString *regex = @"(?<=<div class=\"bibDisplayContentMain\">)(.|\n)*?(?=</div></div>)";
    NSString *resultStr = [HiHelper stringFormString:html withRegular:regex];    //正则表达式抓取消息
        
    if (resultStr.length <=0 ) {
        return nil;
    }
    
    //处理链接, 都给他删除了
    NSString *regexTag = @"href=\".*\"";
    NSArray *hrefArray = [HiHelper arrayFromString:resultStr withRegular:regexTag];
    for (int i = 0; i < hrefArray.count; ++i) {
        resultStr = [resultStr stringByReplacingOccurrencesOfString:[hrefArray objectAtIndex:i] withString:@""];//去掉href
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bookinfo" ofType:@"html"];
    NSString *rHtml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    rHtml = [rHtml stringByReplacingOccurrencesOfString:@"#info#" withString:resultStr];
    
    return rHtml;
}

+(NSString *)xidianBookInfoFromURL:(NSURL *)url    //返回西电图书详情
{
    //
    //请求数据
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *urlContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    if(!urlContents)
    {
        return nil;
        
    }
    return [self xidianBookInfoFromHtml:urlContents];
}

#pragma mark ------
#pragma mark 西交通
+(NSString *)xijiaotongBookHtmlFromKeyword:(NSString *)key withPage:(NSInteger)page //获取西交通关键字的html
{
    /*
     String params="/search~/a?" + "searchtype=t"+ "&searcharg="
     + keyWord+ "&SORT=D";
     */
    
    //
    //请求数据
    NSString *urlStr = [NSString stringWithFormat:@"%@/search*chx/i?SEARCH=%@", kbXijiaotongURL, key];
    NSLog(@"%@", urlStr);
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSError *err = nil;
    NSString *urlContents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    
    if(urlContents.length <= 0)
    {
        NSLog(@"err %@",err);
        return nil;
        
    }
    return urlContents;
}

+(NSString *)xijiaotongBookHtmlFromISBN:(NSString *)key withPage:(NSInteger)page //获取西交通关键字的html
{
    /*
     String params="/search~/a?" + "searchtype=t"+ "&searcharg="
     + keyWord+ "&SORT=D";
     */
    
    //
    //请求数据
    NSString *urlStr = [NSString stringWithFormat:@"%@/search/i?SEARCH=%@&SORT=D", kbXijiaotongURL, key];
    NSLog(@"%@", urlStr);
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSError *err = nil;
    NSString *urlContents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    
    if(urlContents.length <= 0)
    {
        NSLog(@"err %@",err);
        return nil;
        
    }
    return urlContents;
}

+(NSArray *)xijiaotongBookListFromHtml:(NSString *)urlContents    //返回西交通图书数组
{
    if (urlContents == nil) {
        return nil;
    }
    //NSLog(@"urlContents %@", urlContents);
    NSString *regexTag = @"(?<=<td align=\"center\" rowspan=\"1\" class=\"browseEntryMark\">)(.|\n)*?(?=</td>\n\n)";
    NSArray *trArray = [HiHelper arrayFromString:urlContents withRegular:regexTag];
    NSMutableArray *resultArray = [[NSMutableArray alloc]initWithCapacity:trArray.count];
    
    for (int i = 0; i<trArray.count; ++i) {
        //详情URL
        NSString *urlRegex = @"(?<=<a href=\").*(?=\">)";
        NSString *urlStr = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:urlRegex];
        urlStr = [NSString stringWithFormat:@"%@%@",kbXijiaotongURL, urlStr];   //加上个根URL
        
        //标题
        NSString *titleRegex = @"(?<=\">).*(?=</a>)";
        NSString *titleStr = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:titleRegex];
        NSString *title2Regex = @"(?<=</a>  ):(.|\n)*?(?=</td>)";
        NSString *title2Str = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:title2Regex];
        titleStr = [titleStr stringByAppendingString:title2Str];
        //删除空格, 删除换行
        titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//去掉换行
        titleStr = [titleStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];//去掉空格
        
        //出版时间
        NSString *timeRegex = @"(?<=class=\"browseEntryYear\">)(.|\n)*?(?=</td>)";
        NSString *timeStr = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:timeRegex];
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//去掉换行
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];//去掉换行
        
        //NSLog(@"%@\n%@\n%@", urlStr, titleStr, timeStr);
        
        //生成字典
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:urlStr, kbDicKeyURL,
                             titleStr, kbDicKeyTitle,
                             timeStr, kbDicKeyTime,                                                                    nil];
        [resultArray addObject:dic];
    }
    
    
    //NSLog(@"result array :%@", resultArray);
    
    return resultArray;
}

+(NSString *)xijiaotongBookInfoFromHtml:(NSString *)html   //返回西交通图书详情
{
    NSString *regex = @"(?<=<!-- BEGIN INNER BIB TABLE -->)(.|\n)*?(?=<!-- END INNER BIB TABLE -->)";
    NSString *bookInfo = [HiHelper stringFormString:html withRegular:regex];    //图书信息
    
    NSString *holdingRegex = @"(?<=<span class=\"bibItems\">)(.|\n)*?(?=</span>)";
    NSString *holdingInfo = [HiHelper stringFormString:html withRegular:holdingRegex];    //图书信息
    
    NSString *resultStr = [bookInfo stringByAppendingString:holdingInfo];
    if (resultStr.length <=0 ) {
        return nil;
    }
    
    //处理链接, 都给他删除了
    NSString *regexTag = @"href=\".*\"";
    NSArray *hrefArray = [HiHelper arrayFromString:resultStr withRegular:regexTag];
    for (int i = 0; i < hrefArray.count; ++i) {
        resultStr = [resultStr stringByReplacingOccurrencesOfString:[hrefArray objectAtIndex:i] withString:@""];//去掉href
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bookinfo" ofType:@"html"];
    NSString *rHtml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    rHtml = [rHtml stringByReplacingOccurrencesOfString:@"#info#" withString:resultStr];
    
    return rHtml;
}

+(NSString *)xijiaotongBookInfoFromURL:(NSURL *)url    //返回西交通图书详情
{
    //
    //请求数据
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *urlContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(!urlContents)
    {
        return nil;
        
    }
    return [self xijiaotongBookInfoFromHtml:urlContents];
}




#pragma mark ------
#pragma mark 西工大


+(NSString *)xigongdaBookHtmlFromKeyword:(NSString *)key withPage:(NSInteger)page //获取西工大关键字的html
{
    /*
     String params="/search~/a?" + "searchtype=t"+ "&searcharg="
     + keyWord+ "&SORT=D";
     */
    
    //
    //请求数据
    NSString *urlStr = [NSString stringWithFormat:@"%@openlink.php?strSearchType=title&match_flag=forward&strText=%@&doctype=ALL", kbXigongdaURL, key];
    NSLog(@"%@", urlStr);
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSError *err = nil;
    NSString *urlContents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    NSLog(@"%@", urlContents);
    if(urlContents.length <= 0)
    {
        NSLog(@"err %@",err);
        return nil;
        
    }
    return urlContents;
}

+(NSString *)xigongdaBookHtmlFromISBN:(NSString *)key withPage:(NSInteger)page //获取西工大关键字的html
{
    /*
     String params="/search~/a?" + "searchtype=t"+ "&searcharg="
     + keyWord+ "&SORT=D";
     */
    
    //
    //请求数据
    NSString *urlStr = [NSString stringWithFormat:@"%@openlink.php?strSearchType=isbn&historyCount=1&strText=%@", kbXigongdaURL, key];
    NSLog(@"%@", urlStr);
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSError *err = nil;
    NSString *urlContents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    NSLog(@"%@", urlContents);
    if(urlContents.length <= 0)
    {
        NSLog(@"err %@",err);
        return nil;
        
    }
    return urlContents;
}

+(NSArray *)xigongdaBookListFromHtml:(NSString *)urlContents    //返回西工大图书数组
{
    if (urlContents == nil) {
        return nil;
    }
    //NSLog(@"urlContents %@", urlContents);
    NSString *regexTag = @"<li class=\"book_list_info\">(.|w|\n|\r)*?</li>";
    NSArray *trArray = [HiHelper arrayFromString:urlContents withRegular:regexTag];
    NSMutableArray *resultArray = [[NSMutableArray alloc]initWithCapacity:trArray.count];
    
    for (int i = 0; i<trArray.count; ++i) {
        //详情URL
        NSString *urlRegex = @"(?<=<a href=\")(.|w|\n)*?(?=\")";
        NSString *urlStr = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:urlRegex];
        urlStr = [NSString stringWithFormat:@"%@%@",kbXigongdaURL, urlStr];   //加上个根URL
        
        //标题
        NSString *titleRegex = @"(?<=\" >(\\d\\d|\\d)\\.)(.|w|\n)*?(?=</a>)";
        NSString *titleStr = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:titleRegex];
        NSString *title2Regex = @"(?<=</span>)(.|\n|w)*?(?=<br />)";    //作者
        NSString *title2Str = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:title2Regex];
        titleStr = [titleStr stringByAppendingString:@"/"];
        titleStr = [titleStr stringByAppendingString:title2Str];
        //删除空格, 删除换行
        titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//去掉换行
        titleStr = [titleStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];//去掉空格
        
        //出版时间
        NSString *timeRegex = @"(?<=<br />\r\n	            )(.|\n|w)*?(?=<br />)";
        NSString *timeStr = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:timeRegex];
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//去掉换行
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];//去掉换行
        
        //概要信息
        NSString *info1Regex = @"馆藏复本(.|\n|w)*?(?=<br>)";
        NSString *info1Str = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:info1Regex];
        NSString *info2Regex = @" 可借复本(.|\n|w)*?(?=</span>)";
        NSString *info2Str = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:info2Regex];
        NSString *infoStr = [info1Str stringByAppendingString:info2Str];
        infoStr = [infoStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//去掉换行
        infoStr = [infoStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];//去掉换行
        
        //NSLog(@"%@\n%@\n%@", urlStr, titleStr, timeStr);
        
        titleStr = [self replaceUnicode:titleStr];
        timeStr = [self replaceUnicode:timeStr];
        //生成字典
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:urlStr, kbDicKeyURL,
                             titleStr, kbDicKeyTitle,
                             timeStr, kbDicKeyTime,
                             infoStr, kbDicKeyInfo, nil];
        [resultArray addObject:dic];
    }
    
    
    NSLog(@"result array :%@", resultArray);
    
    return resultArray;
}

+(NSString *)xigongdaBookInfoFromHtml:(NSString *)html   //返回西工大图书详情
{
    NSString *regex = @"<dl class=\"booklist\">(.|\n|\r|w)*?</dl>";
    NSArray *trArray = [HiHelper arrayFromString:html withRegular:regex];
    if (trArray.count <= 0) {
        return nil;
    }
    
    NSString *bookinfo = [NSString stringWithFormat:@"%@%@%@", [trArray objectAtIndex:0],[trArray objectAtIndex:1],[trArray objectAtIndex:2] ];
    
    NSString *holdingRegex = @"<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"5\" cellspacing=\"0\" id=\"item\">(.|\n|\r|w)*?</table>";
    NSString *holdingStr = [HiHelper stringFormString:html withRegular:holdingRegex];    //图书藏书信息
    
    NSString *resultStr = [bookinfo stringByAppendingString:holdingStr];
    
    if (resultStr.length <=0 ) {
        return nil;
    }
    
    //处理链接, 都给他删除了
    NSString *regexTag = @"href=\".*\"";
    NSArray *hrefArray = [HiHelper arrayFromString:resultStr withRegular:regexTag];
    for (int i = 0; i < hrefArray.count; ++i) {
        resultStr = [resultStr stringByReplacingOccurrencesOfString:[hrefArray objectAtIndex:i] withString:@""];//去掉href
    }
    
    NSString *imgRegexTag = @"<img.*?>";
    NSArray *imgArray = [HiHelper arrayFromString:resultStr withRegular:imgRegexTag];
    for (int i = 0; i < imgArray.count; ++i) {
        resultStr = [resultStr stringByReplacingOccurrencesOfString:[imgArray objectAtIndex:i] withString:@""];//去掉img
    }
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"border=\"0\"" withString:@"border=\"1\""];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bookinfo" ofType:@"html"];
    NSString *rHtml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    rHtml = [rHtml stringByReplacingOccurrencesOfString:@"#info#" withString:resultStr];
    
    return rHtml;
}

+(NSString *)xigongdaBookInfoFromURL:(NSURL *)url    //返回西工大图书详情
{
    //
    //请求数据
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *urlContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(!urlContents)
    {
        return nil;
        
    }
    return [self xigongdaBookInfoFromHtml:urlContents];
}

#pragma mark ------
#pragma mark 陕西师大
+(NSString *)shaanxiNormalBookHtmlFromKeyword:(NSString *)key withPage:(NSInteger)page //获取陕西师大关键字的html
{
    /*
     String params="/search~/a?" + "searchtype=t"+ "&searcharg="
     + keyWord+ "&SORT=D";
     */
    
    //
    //请求数据
    NSString *urlStr = [NSString stringWithFormat:@"%@/?func=find-b&find_code=WRD&request=%@", kbShaanxiNormalURL, key];
    NSLog(@"%@", urlStr);
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSError *err = nil;
    NSString *urlContents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    
    if(urlContents.length <= 0)
    {
        NSLog(@"err %@",err);
        return nil;
        
    }
    return urlContents;
}

+(NSString *)shaanxiNormalBookHtmlFromISBN:(NSString *)key withPage:(NSInteger)page //获取陕西师大关键字的html
{
    /*
     String params="/search~/a?" + "searchtype=t"+ "&searcharg="
     + keyWord+ "&SORT=D";
     */
    
    //
    //请求数据
    NSString *urlStr = [NSString stringWithFormat:@"%@/?func=find-b&find_code=ISB&request=%@", kbShaanxiNormalURL, key];
    NSLog(@"%@", urlStr);
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSError *err = nil;
    NSString *urlContents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    
    if(urlContents.length <= 0)
    {
        NSLog(@"err %@",err);
        return nil;
        
    }
    return urlContents;
}

+(NSArray *)shaanxiNormalBookListFromHtml:(NSString *)urlContents    //返回陕西师大图书数组
{
    if (urlContents == nil) {
        return nil;
    }
    //NSLog(@"urlContents %@", urlContents);
    NSString *regexTag = @"<td class=col2>(.|\n)*?<hr class=itemsep size=1>";
    NSArray *trArray = [HiHelper arrayFromString:urlContents withRegular:regexTag];
    NSMutableArray *resultArray = [[NSMutableArray alloc]initWithCapacity:trArray.count];
    
    for (int i = 0; i<trArray.count; ++i) {
        NSString *arrayIStr = [trArray objectAtIndex:i];
        //详情URL
        NSString *urlRegex = @"(?<=<a href=')(.|\n)*?(?=')";
        NSString *urlStr = [HiHelper stringFormString:arrayIStr withRegular:urlRegex];
        
        //删除中间的URL
        NSString *regexTag = @"<a href=.*?>";
        NSArray *hrefArray = [HiHelper arrayFromString:arrayIStr withRegular:regexTag];
        for (int i = 0; i < hrefArray.count; ++i) {
            arrayIStr = [arrayIStr stringByReplacingOccurrencesOfString:[hrefArray objectAtIndex:i] withString:@""];//去掉href
        }
        NSLog(@"%@", arrayIStr);
        //标题
        NSString *titleRegex = @"(?<=<div class=itemtitle>).*?(?=</a>)";
        NSString *titleStr = [HiHelper stringFormString:arrayIStr withRegular:titleRegex];
        NSString *title2Regex = @"(?<=<td class=content valign=top>).*?(?=<td class=label1>)";
        NSString *title2Str = [HiHelper stringFormString:arrayIStr withRegular:title2Regex];
        titleStr = [titleStr stringByAppendingString:@" / "];
        titleStr = [titleStr stringByAppendingString:title2Str];
        //删除空格, 删除换行
        titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//去掉换行
        titleStr = [titleStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];//去掉空格
        
        //出版时间
        NSString *timeRegex = @"(?<=出版社：<td class=content valign=top>).*?(?=\n<tr>)";
        NSString *timeStr = [HiHelper stringFormString:arrayIStr withRegular:timeRegex];
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"<td class=label>年份：<td class=content valign=top>" withString:@"  "];//去掉多余的
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//去掉换行
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];//去掉换行
        
        //NSLog(@"%@\n%@\n%@", urlStr, titleStr, timeStr);
        
        //概要信息
        NSString *infoRegex = @"(?<=\\)\">)(.|\n|w)*?(?=</a>)";
        NSString *infoStr = [HiHelper stringFormString:[trArray objectAtIndex:i] withRegular:infoRegex];
        infoStr = [infoStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//去掉换行
        infoStr = [infoStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];//去掉换行
        
        //生成字典
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:urlStr, kbDicKeyURL,
                             titleStr, kbDicKeyTitle,
                             timeStr, kbDicKeyTime,
                             infoStr, kbDicKeyInfo, nil];
        
        [resultArray addObject:dic];
    }
    
    
    NSLog(@"result array :%@", resultArray);
    
    return resultArray;
}

+(NSString *)shaanxiNormalBookInfoFromHtml:(NSString *)html   //返回陕西师大图书详情
{
    //判断是哪个页面. 一共有三个, 列表面, 内容页, 和馆藏页
    //列表页返回nil
    //内容页加载html, 递归此函数,
    if ([html rangeOfString:@"<title>陕师大中文库 - Search Results</title>"].location != NSNotFound) {
        return nil;
    }
    
    if ([html rangeOfString:@"<title>陕师大中文库 - 查看完整记录 </title>"].location != NSNotFound) {
        NSString *urlRegex = @"(?<=</script><A HREF=)(.|\n)*?(?=>所有单册</A>)";
        NSString *urlStr = [HiHelper stringFormString:html withRegular:urlRegex];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlStr];
        
        return [self shaanxiNormalBookInfoFromURL:url];
    }
    
    NSString *titleRegex = @"(?<=<hr> \n)<table width=99%>(.|\n)*?</table>";
    NSString *titleStr = [HiHelper stringFormString:html withRegular:titleRegex];    //图书信息
    
    if (titleStr.length <=0 ) {
        return nil;
    }
    
    NSString *holdingRegex = @"<table border=0 cellspacing=2 width=99%>(.|\n)*?</table>";
    NSString *holdingStr = [HiHelper stringFormString:html withRegular:holdingRegex];    //馆藏
    
    NSString *resultStr = [titleStr stringByAppendingString:@"<br>"];
    resultStr = [resultStr stringByAppendingString:holdingStr];
    
    if (resultStr.length <=0 ) {
        return nil;
    }
    
    //处理链接, 都给他删除了
    NSString *regexTag = @"href=\".*\"";
    resultStr = [self delStringWithString:resultStr withRegex:regexTag];
    //处理表格
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"border=0" withString:@"border=1"];
    
    //删除扩展那列
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"<th class=\"text3\">&nbsp;</th>" withString:@""];    
    regexTag = @"(?<=<tr> \n  )<td class=td1><a href=(.|\n)*?</td>";
    resultStr = [self delStringWithString:resultStr withRegex:regexTag];
    
    //删除描述那列
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"<th class=\"text3\">描述</th>" withString:@""];
    regexTag = @"<!--Description--> \n  <td class=td1>(.|\n)*?</td>";
    resultStr = [self delStringWithString:resultStr withRegex:regexTag];
    
    //删除后面那几列
    regexTag = @"<th class=\"text3\">请求数</th>(.|\n)*?<th class=\"text3\">馆藏信息</th>";
    resultStr = [self delStringWithString:resultStr withRegex:regexTag];
    regexTag = @"<!--Pages-->(.|\n)*?<!--SFX-->";
    resultStr = [self delStringWithString:resultStr withRegex:regexTag];
    
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bookinfo" ofType:@"html"];
    NSString *rHtml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    rHtml = [rHtml stringByReplacingOccurrencesOfString:@"#info#" withString:resultStr];
    
    return rHtml;
}

+(NSString *)shaanxiNormalBookInfoFromURL:(NSURL *)url    //返回陕西师大图书详情
{
    //
    //请求数据
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *urlContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(!urlContents)
    {
        return nil;
        
    }
    return [self shaanxiNormalBookInfoFromHtml:urlContents];
}



@end
