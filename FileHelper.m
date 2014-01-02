//
//  FileHelper.m
//  InvitCard
//
//  Created by 航 吕 on 12-10-14.
//  Copyright (c) 2012年 青舟. All rights reserved.
//

#import "FileHelper.h"

NSString *documentsFolder()
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

NSString *bundleFolder()
{
    return [[NSBundle mainBundle] bundlePath];
}

@implementation FileHelper

//返回一个文件完整的路径
+(NSString *) pathForItemNamed:(NSString *) fname inFolder:(NSString *)path
{
    NSString *file;
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    
    while (file = [dirEnum nextObject]) 
    {
        if([[file lastPathComponent] isEqualToString:fname])
        {
            return [path stringByAppendingPathComponent:file];
        }
    }
    return nil;
}


//根据文件名返回文件路径，先从document中找，再从mainbundle中找。
+(NSString *) pathFromNamed:(NSString *) fname
{
    NSString *path = [FileHelper pathForItemNamed:fname inFolder:documentsFolder()];
    path = path ? path : [FileHelper pathForItemNamed:fname inFolder:bundleFolder()];
    if (!path) {
        return nil;
    }
    return path;
}

//删除documentsFolder 中的文件
+(void)deleteFile:(NSString *)fileName
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [self pathForItemNamed:fileName inFolder:documentsFolder()];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!blHave)
    {
        NSLog(@"no  have");
        return ;
    }
    else
    {
        NSLog(@" have");
        BOOL blDele= [fm removeItemAtPath:path error:nil];
        if (blDele)
        {
            NSLog(@"dele success");
        }
        else
        {
            NSLog(@"dele fail");
        }
    }
}


//保存操作
+(void)saveDic:(NSDictionary *)dic withName:(NSString *)filename
{
    NSString *path = [documentsFolder() stringByAppendingPathComponent:filename];
    [dic writeToFile:path atomically:NO];
}

+(NSDictionary *)readDicFile:(NSString *)fileName
{
    return [NSDictionary dictionaryWithContentsOfFile:[self pathFromNamed:fileName]];
}

+(void)saveArray:(NSArray *)array withName:(NSString *)filename
{
    NSString *path = [documentsFolder() stringByAppendingPathComponent:filename];
    [array writeToFile:path atomically:NO];
}

+(NSArray *)readArrayFile:(NSString *)fileName
{
    return [NSArray arrayWithContentsOfFile:[self pathFromNamed:fileName]];
}

+(void)saveString:(NSString *)string withName:(NSString *)filename
{
    NSString *path = [documentsFolder() stringByAppendingPathComponent:filename];
    [string writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

+(NSString *)readStringFile:(NSString *)fileName
{
    return [NSString stringWithContentsOfFile:[self pathFromNamed:fileName] encoding:NSUTF8StringEncoding error:nil];
}

@end
