//
//  FileHelper.h
//  InvitCard
//
//  Created by 航 吕 on 12-10-14.
//  Copyright (c) 2012年 青舟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject
//返回一个文件完整的路径
+(NSString *) pathForItemNamed:(NSString *) fname inFolder:(NSString *)path;

//根据文件名返回文件路径，先从document中找，再从mainbundle中找。
+(NSString *) pathFromNamed:(NSString *) fname;

//删除documentsFolder 中的文件
+(void)deleteFile:(NSString *)fileName;

//保存读取操作 
+(void)saveDic:(NSDictionary *)dic withName:(NSString *)filename;

+(NSDictionary *)readDicFile:(NSString *)fileName;

+(void)saveArray:(NSArray *)array withName:(NSString *)filename;

+(NSArray *)readArrayFile:(NSString *)fileName;

+(void)saveString:(NSString *)array withName:(NSString *)filename;

+(NSString *)readStringFile:(NSString *)fileName;

@end
