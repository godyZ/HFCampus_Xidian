//
//  RESTfulEngine.h
//  hifcampus
//
//  Created by jackie on 13-10-14.
//  Copyright (c) 2013年 xidian. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "RESTfulOperation.h"
#import "MenuItem.h"
#import "DetailItem.h"
#import "PeopleItem.h"

typedef void (^VoidBlock) (void);
typedef void (^UserBlock) (NSDictionary * userInfo);
typedef void (^ModelBlock) (JSONModel *aBaseModel);
typedef void (^ArrayBlock) (NSMutableArray *listOfModelObjects);
typedef void (^ErrorBlock) (NSError* engineError);
typedef void (^DetailItemBlock) (DetailItem *aDetailItem);


@interface RESTfulEngine : MKNetworkEngine
-(RESTfulOperation*)registerWithName:(NSString *)name
                                email:(NSString *)email
                               passwd:(NSString *)passwd
                                image:(UIImage *)img
                            onSuccess:(UserBlock)userInfo
                              onError:(ErrorBlock)errorBlock;

-(RESTfulOperation*)loginWithName:(NSString *)loginName
                         password:(NSString *)password
                       onSucceede:(UserBlock)successBlock
                          onError:(ErrorBlock)errorBlock;

-(RESTfulOperation*)fetchMenuItemsForPath:(NSString *)path
                                onSucceed:(ArrayBlock)successBlock
                                  onError:(ErrorBlock)errorBlock;

-(RESTfulOperation *)fetchDetailForPath:(NSString *)path
                              onSucceed:(DetailItemBlock)successBlock
                                onError:(ErrorBlock)errorBlock;

-(RESTfulOperation*)fetchPeopleItemsForPath:(NSString *)path
                                onSucceed:(ArrayBlock)successBlock
                                  onError:(ErrorBlock)errorBlock;
@end
