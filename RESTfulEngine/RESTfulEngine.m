//
//  RESTfulEngine.m
//  hifcampus
//
//  Created by jackie on 13-10-14.
//  Copyright (c) 2013年 xidian. All rights reserved.
//

#import "RESTfulEngine.h"


@implementation RESTfulEngine

/*
 登录功能
 */
-(RESTfulOperation*)loginWithName:(NSString *)loginName
                         password:(NSString *)password
                       onSucceede:(UserBlock)successBlock
                          onError:(ErrorBlock)errorBlock{
    
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithObjectsAndKeys:loginName,@"email",password,@"password", nil];
    RESTfulOperation *op = (RESTfulOperation *)[self operationWithPath:LOGIN_URL params:body httpMethod:@"POST"];
//    [op  operationWithPath:LOGIN_URL
//                    params:(NSMutableDictionary*) body
//                httpMethod:(NSString*)method];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        NSDictionary *responseDic = [ completedOperation responseJSON];
        successBlock(responseDic);
    } onError: errorBlock];
    [self enqueueOperation:op];
    return op;
}

-(RESTfulOperation *)fetchMenuItemsForPath:(NSString *)path
                                 onSucceed:(ArrayBlock)successBlock
                                   onError:(ErrorBlock)errorBlock
{
    RESTfulOperation *op = (RESTfulOperation *)[self operationWithPath:path];
    [op onCompletion:^(MKNetworkOperation *completedOperation){
        //处理相关数据
        NSMutableDictionary *responseDictionary = [completedOperation responseJSON];
        //DLog(@"response data is %@",responseDictionary);
        NSMutableArray *menuItemsJson = [responseDictionary objectForKey:@"data"];
        NSMutableArray *menuItems = [NSMutableArray array];
        [menuItemsJson enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
            [menuItems addObject:[[MenuItem alloc]initWithDictionary:obj]];
        }];
        
        successBlock(menuItems);
    }onError:errorBlock];
    [self enqueueOperation:op];
    return op;
}

-(RESTfulOperation *)fetchDetailForPath:(NSString *)path
                                 onSucceed:(DetailItemBlock)successBlock
                                   onError:(ErrorBlock)errorBlock
{
    RESTfulOperation *op = (RESTfulOperation *)[self operationWithPath:path];
    [op onCompletion:^(MKNetworkOperation *completedOperation){
        //处理相关数据
        NSMutableDictionary *responseDictionary = [completedOperation responseJSON];
        DetailItem *detailItem = [[DetailItem alloc]initWithDictionary:[responseDictionary objectForKey:@"data"]];
        successBlock(detailItem);
    }onError:errorBlock];
    [self enqueueOperation:op];
    return op;
}

-(RESTfulOperation*)fetchPeopleItemsForPath:(NSString *)path
                                  onSucceed:(ArrayBlock)successBlock
                                    onError:(ErrorBlock)errorBlock{
    RESTfulOperation *op = (RESTfulOperation *)[self operationWithPath:path];
    [op onCompletion:^(MKNetworkOperation *completedOperation){
        //处理相关数据
        NSMutableDictionary *responseDictionary = [completedOperation responseJSON];
        //DLog(@"response data is %@",responseDictionary);
        NSMutableArray *menuItemsJson = [responseDictionary objectForKey:@"data"];
        NSMutableArray *menuItems = [NSMutableArray array];
        [menuItemsJson enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
            [menuItems addObject:[[PeopleItem alloc]initWithDictionary:obj]];
        }];
        successBlock(menuItems);
    }onError:errorBlock];
    [self enqueueOperation:op];
    return op;
}

-(RESTfulOperation *)registerWithName:(NSString *)name
                                email:(NSString *)email
                               passwd:(NSString *)passwd
                                image:( UIImage *)img
                            onSuccess:(UserBlock)userInfo
                              onError:(ErrorBlock)errorBlock
{
    
//    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithObjectsAndKeys:name,"nickname",email,@"email",passwd,@"password", nil];
    NSLog(@"%@",name);
    NSMutableDictionary *body = [[NSMutableDictionary alloc]init];
    [body setObject:name forKey:@"nickname"];
    [body setObject:email forKey:@"email"];
    [body setObject:passwd forKey:@"password"];
    //[body setObject:<#(id)#> forKey:<#(id<NSCopying>)#>]
                                 //initWithObjectsAndKeys:name,"nickname",email,@"email",passwd,@"password", nil];
    RESTfulOperation *op = (RESTfulOperation *)[self operationWithPath:REGISTER_URL params:body httpMethod:@"POST"];
   
    if (img) {
        NSData *image = UIImageJPEGRepresentation(img, 1.0);
        [op addData:image forKey:@"thumbnail " mimeType:@"image/jpeg" fileName:@"thumbnail.jpeg"];
    }
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        NSDictionary *responseDic = [ completedOperation responseJSON];
        userInfo(responseDic);
    } onError: errorBlock];
    [self enqueueOperation:op];
    return op;
}

@end
