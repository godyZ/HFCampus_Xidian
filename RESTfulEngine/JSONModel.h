//
//  JSONModel.h
//  hifcampus
//
//  Created by jackie on 13-10-14.
//  Copyright (c) 2013年 xidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONModel : NSObject<NSCopying,NSCoding,NSMutableCopying>{
}

-(id) initWithDictionary:(NSMutableDictionary*)jsonObject;

@end
