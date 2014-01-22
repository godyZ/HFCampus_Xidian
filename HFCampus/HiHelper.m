//
//  HiHelper.m
//  hifcampus
//
//  Created by Hank on 13-1-14.
//  Copyright (c) 2013年 Hank. All rights reserved.
//

#import "HiHelper.h"
#import <CommonCrypto/CommonDigest.h>

//#import "GTMBase64.h"

//#import "GlobalConst.h"
//#import "JSONKit.h"

//#import "SVProgressHUD.h"

@implementation HiHelper

//----------类型-----
+(NSArray *)typeNameArray   //类型名称
{
    return  [NSArray arrayWithObjects: @"讲座", @"糗事", @"校园新闻",
             @"兼职", @"招聘", @"精彩活动",
              @"团购",nil];
}

+(NSArray *)typeCodeArray   //类型代码
{
    return  [NSArray arrayWithObjects: @"3", @"6", @"1",
             @"4", @"2", @"5",
             @"7",nil];
}

+(NSArray *)typeKeysArray    //类型关键字
{
    return [[NSArray alloc] initWithObjects:@"news",@"job", @"lecture",@"partjob",@"activity",@"qiushi",@"buy",nil];
}


+(NSArray *)typeCellIDArray //类型CellID
{
    return  [NSArray arrayWithObjects: @"TYPE_LECTURE_CELL", @"TYPE_QIUSHI_CELL", @"TYPE_NEWS_CELL",
             @"TYPE_PARTTIME_CELL", @"TYPE_JOP_CELL", @"TYPE_ACT_CELL",
             @"TYPE_BUY_CELL",nil];
}


//--------学校------
+(NSArray *)schoolNameArray   //学校名称
{
    return  [NSArray arrayWithObjects: @"西安电子科技大学", @"西安交通大学",
             @"西北工业大学",@"陕西师范大学",
             @"西北大学",nil];
}

+(NSArray *)schoolCodeArray //学校代码
{
    return  [NSArray arrayWithObjects:@"1", @"2",
             @"3", @"4",
             @"5",nil];
}


//------图像----
+(UIImage *)imageFromColor:(UIColor *)color    //颜色转为图像
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}



//+(void)changeBtnImgAndTitlePos:(UIButton *)btn //交换按钮中图像和标题的位置
//{
//    //UIControlContentHorizontalAlignment state = btn.contentHorizontalAlignment;
//    
//    //btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    CGFloat imgWidth = btn.imageView.image.size.width;
//    CGFloat titleWidth = [btn.titleLabel.text sizeWithFont:[btn.titleLabel font]].width;
//    
//    //CGRect rect = [btn contentRectForBounds:btn.bounds];
//    //NSLog(@"content width:%f,  btn width:%f  font size:%@", rect.size.width, btn.bounds.size.width, [btn.titleLabel font]);
//    
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, titleWidth , 0, -titleWidth)];
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgWidth, 0, imgWidth)];    
//}

#pragma mark ------------
#pragma mark 正则

+(NSArray *)arrayFromString:(NSString *)htmlString  withRegular:(NSString *)regString   //通过正则返回所有匹配项
{
    NSError *error =    nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regString options:0 error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:htmlString
                                      options:0
                                        range:NSMakeRange(0, [htmlString length])];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:matches.count];
    // 用下面的办法来遍历每一条匹配记录
    
    for (NSTextCheckingResult *match in matches) {
        
        NSRange matchRange = [match range];
        
        NSString *tagString = [htmlString substringWithRange:matchRange];  // 整个匹配串
        [resultArray addObject:tagString];
        NSLog(@"%@", tagString);
        
        /*
         NSRange r1 = [match rangeAtIndex:1];
         if (!NSEqualRanges(r1, NSMakeRange(NSNotFound, 0))) {    // 由时分组1可能没有找到相应的匹配，用这种办法来判断
         NSString *tagName = [pgnText substringWithRange:r1];  // 分组1所对应的串
         
         }
         
         NSString *tagValue = [pgnText substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
         */
        
    }
    
    return resultArray;
}

+(NSString*)stringFormString:(NSString *)string withRegular:(NSString *)regString   //通过正则表达式返回第一个字符串
{
    if (string == nil) {
        return @"";
    }
    
    NSString *result = @"";
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regString options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            //从html中截取数据
            result = [string substringWithRange:resultRange];
            NSLog(@"%@",result);
        }
        else
        {
            return @"";
        }
    }
    else
    {
        return @"";
    }
    
    return result;
}

#pragma mark ------------------------------
#pragma mark 验证

+(BOOL)isValidatePhoneNum:(NSString *)text{ //验证电话
    
    //NSString *regex =@"(13[0-9]|14[0-9]|0[1-9][0-9][0-9]|0[1-9][0-9]|0[1-9]|15[0-9]|18[0-9])\\d{8}";
    NSString *regex =@"(13[0-9]|14[0-9]|15[0-9]|18[0-9])\\d{8}";
    
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [mobileTest evaluateWithObject:text];
}


//利用正则表达式验证邮箱合法性
+(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

//利用正则表达式验证URL的合法性
+(BOOL)isValidateURL:(NSString *)url {
    
    NSString *emailRegex = @"http://[^\\s]*";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:url];
    
}


#pragma mark -
#pragma mark 网络请求
/*
+(NSDictionary *)dicFromApi:(NSString *)apiStr withRequstStr:(NSString *)reqStr //请求数据
{
    //测试
    NSURL *myURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kApiURL, apiStr]];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:myURL];
    [myRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [myRequest setHTTPMethod:@"POST"];
    NSData *myData = [reqStr dataUsingEncoding:NSUTF8StringEncoding];
    [myRequest setHTTPBody:myData];
    NSURLResponse *response;
    NSError *error = nil;
    NSData *myReturn = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:&response error:&error];
    if (error != nil) {
        NSLog(@"请求出错:%@",[error description] );
        return nil;
    }
    
    return [myReturn objectFromJSONData];
}

+(NSInteger)dealRequestDic:(NSDictionary *)dic   //处理请求的字典
{
    if (dic == nil) {
        [SVProgressHUD showErrorWithStatus:@"网络错误!"];
        return NO;
    }
    NSInteger title = [[dic objectForKey:@"title"] integerValue];
    switch (title) {
        case 1:
            break;
            
        case 0:
            [SVProgressHUD showErrorWithStatus:@"请求失败!"];
            break;
        case 500:
            [SVProgressHUD showErrorWithStatus:@"服务器异常!"];
            break;
        case 21:
            [SVProgressHUD showErrorWithStatus:@"密钥错误, 请联系管理员!"];
            break;
        case 3:
            //[SVProgressHUD showSuccessWithStatus:@"没有更新的数据了!"];
            break;
        case 22:
            [SVProgressHUD showErrorWithStatus:@"用户名或密码错误!"];
            break;
        
        default:
            [SVProgressHUD showErrorWithStatus:@"未知错误!"];
            break;
    }
    return title;
    
}
 */

#pragma mark - 
#pragma mark 加密类


+ (NSString *)md5Digest:(NSString *)str{    //TODO: md5 加密方法
    
    const char *cStr = [str UTF8String];    
    unsigned char result[CC_MD5_DIGEST_LENGTH];    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
        
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
}


//+ (NSString*) base64Decode:(NSString *)string //加密base64
//
//{
//    
//    NSData *decryptData = [GTMBase64 decodeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSString *returnStr = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
//    if (returnStr == nil) {
//        return @"";
//    }
//    return returnStr;
//    
//}
//
//+ (NSString*) base64Encode:(NSString *)string   //解码base64
//{
//    NSData* encryptData = [string dataUsingEncoding:NSUTF8StringEncoding];
//     return [[NSString alloc] initWithData:[GTMBase64 encodeData:encryptData] encoding:NSUTF8StringEncoding];
//}

//-------格式化输出时间
+ (NSString *)formatDateFromDateString:(NSString *)dateStr withFormat:(NSString *) formatStr
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:dateStr];
 
    [inputFormatter setDateFormat:formatStr];
    NSString *str = [inputFormatter stringFromDate:inputDate];
    //NSLog(@"testDate:%@", str);
    
    return str;
}

//--------保存数据到本地, 支持集合中的数据.
+(BOOL)saveDic:(NSDictionary *)dic withFilename:(NSString *)filename    //保存数据到本地
{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSLog(@"保存的路径为:%@",path);
    
    return [dic writeToFile:path atomically:YES];
}

+(BOOL)saveArray:(NSArray *)dic withFilename:(NSString *)filename    //保存数组到本地
{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSLog(@"保存的路径为:%@",path);
    
    return [dic writeToFile:path atomically:YES];
}

+(NSDictionary *)getDicFromFilename:(NSString *)filename    //读取DIC
{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSLog(@"读取的路径为:%@",path);
    
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+(NSArray *)getArrayFromFilename:(NSString *)filename    //读取Array
{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSLog(@"读取的路径为:%@",path);
    
    return [NSArray arrayWithContentsOfFile:path];
}

+(BOOL)delFileWithName:(NSString *)filename     //删除文件
{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *error;
    if (![fm removeItemAtPath:path error:&error]) {
        NSLog(@"File remove error: %@", error.localizedDescription);
        return NO;
    }
    return YES;
}

@end
















