//
//  HiHelper.h
//  hifcampus
//
//  Created by Hank on 13-1-14.
//  Copyright (c) 2013年 Hank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HiHelper : NSObject

#pragma mark ---
#pragma mark 常量
+(NSArray *)typeNameArray;   //类型名称
+(NSArray *)typeCodeArray;   //类型代码
+(NSArray *)typeKeysArray;   //类型关键字
+(NSArray *)typeCellIDArray; //类型CellID

+(NSArray *)schoolNameArray;   //学校名称
+(NSArray *)schoolCodeArray; //学校代码

+(UIImage *)imageFromColor:(UIColor *)color;    //颜色转为图像

//+(void)changeBtnImgAndTitlePos:(UIButton *)btn; //交换按钮中图像和标题的位置

#pragma mark ------------
#pragma mark 正则
+(NSString*)stringFormString:(NSString *)string withRegular:(NSString *)regString;   //通过正则表达式返回第一个字符串
+(NSArray *)arrayFromString:(NSString *)htmlString  withRegular:(NSString *)regString;   //通过正则返回所有匹配项

#pragma mark --------------------ß----------
#pragma mark 验证
+(BOOL)isValidateEmail:(NSString *)email ;//利用正则表达式验证邮箱合法性
+(BOOL)isValidatePhoneNum:(NSString *)text; //验证电话
+(BOOL)isValidateURL:(NSString *)url;   //利用正则表达式验证URL的合法性


#pragma mark ------------------------------
#pragma mark 网络请求
/*
+(NSDictionary *)dicFromApi:(NSString *)apiStr withRequstStr:(NSString *)reqStr; //请求数据
+(NSInteger)dealRequestDic:(NSDictionary *)dic;   //处理请求的字典
*/
#pragma mark ------------------------------
#pragma mark 加解密
+ (NSString *)md5Digest:(NSString *)str;   //md5 加密方法
//+ (NSString*) base64Decode:(NSString *)string; //加密base64
//+ (NSString*) base64Encode:(NSString *)string;  //解码base64

//-------格式化输出时间
+ (NSString *)formatDateFromDateString:(NSString *)dateStr withFormat:(NSString *) formatStr;

//--------保存数据到本地, 支持集合中的数据.
+(BOOL)saveDic:(NSDictionary *)dic withFilename:(NSString *)filename;    //保存数据到本地
+(BOOL)saveArray:(NSArray *)dic withFilename:(NSString *)filename;    //保存数组到本地
+(NSDictionary *)getDicFromFilename:(NSString *)filename;    //读取DIC
+(NSArray *)getArrayFromFilename:(NSString *)filename;    //读取Array
+(BOOL)delFileWithName:(NSString *)filename;     //删除文件

@end
