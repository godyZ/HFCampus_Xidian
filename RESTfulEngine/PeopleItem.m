//
//  PeopleItem.m
//  hifcampus
//
//  Created by jackie on 13-10-28.
//  Copyright (c) 2013年 xidian. All rights reserved.
//

#import "PeopleItem.h"

@implementation PeopleItem
/*
 campus_id: 10701,
 thumbnail1: 14804,
 title: "一枚手机发烧友",
 create_time: {
 $date: 1372085626000
 },
 words: "跟着兴趣走能走得更高更远",
 time: 4,
 person_name: "汤浩",
 _id: 10018,
 thumbnail2: 14803
 },
 */

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    
    //人物
    [aCoder encodeObject:self.person_name forKey:@"person_name"];
    [aCoder encodeObject:self.words forKey:@"words"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.thumbnail1 forKey:@"thumbnail1"];
    [aCoder encodeObject:self.thumbnail2 forKey:@"thumbnail2"];
     
}

-(id)initWithCoder:(NSCoder *)aDecoder{
         self = [super initWithCoder:aDecoder];
         if (self) {
             self.person_name = [aDecoder decodeObjectForKey:@"person_name"];
             self.words = [aDecoder decodeObjectForKey:@"words"];
             self.time = [aDecoder decodeObjectForKey:@"time"];
             self.time = [aDecoder decodeObjectForKey:@"thumbnail1"];
             self.thumbnail2 = [aDecoder decodeObjectForKey:@"thumbnail2"];
         }
    return self;
}

@end
