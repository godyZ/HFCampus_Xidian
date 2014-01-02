//
//  DetailItem.m
//  hifcampus
//
//  Created by jackie on 13-10-27.
//  Copyright (c) 2013年 xidian. All rights reserved.
//

#import "DetailItem.h"

@implementation DetailItem

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.content forKey:@"content"];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
    }
    return self;
}
@end
