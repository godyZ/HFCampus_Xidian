//
//  MenuItem.m
//  hifcampus
//
//  Created by jackie on 13-10-16.
//  Copyright (c) 2013年 xidian. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

//===========================================================
//  Keyed Archiving
//
//===========================================================

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.campusId forKey:@"CampusId"];
    [aCoder encodeObject:self.author forKey:@"Author"];
    [aCoder encodeObject:self.author_name forKey:@"AuthorName"];
    [aCoder encodeObject:self.title forKey:@"Title"];
    [aCoder encodeObject:self.thumbnail forKey:@"Thumbnail"];
    [aCoder encodeObject:self.itemId forKey:@"ItemId"];
    [aCoder encodeObject:self.author_thumbnail forKey:@"AuthorThumbnail"];
    [aCoder encodeObject:self.create_time forKey:@"CreateTime"];
    [aCoder encodeObject:self.readFlag forKey:@"ReadedFlag"];
    
     //讲座
    
    [aCoder encodeObject:self.person forKey:@"person"];
    [aCoder encodeObject:self.start_time forKey:@"start_time"];
    [aCoder encodeObject:self.place forKey:@"place"];
    
    //人物
    
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.campusId = [aDecoder decodeObjectForKey:@"CampusId"];
        self.author = [aDecoder decodeObjectForKey:@"Author"];
        self.author_name = [aDecoder decodeObjectForKey:@"AuthorName"];
        self.title = [aDecoder decodeObjectForKey:@"Title"];
        self.thumbnail = [aDecoder decodeObjectForKey:@"Thumbnail"];
        self.itemId = [aDecoder decodeObjectForKey:@"ItemId"];
        self.author_name = [aDecoder decodeObjectForKey:@"AuthorThumbnail"];
        self.create_time = [aDecoder decodeObjectForKey:@"CreateTime"];
        self.readFlag = [aDecoder decodeObjectForKey:@"ReadedFlag"];
        
        //讲座
        self.person = [aDecoder decodeObjectForKey:@"person"];
        self.start_time = [aDecoder decodeObjectForKey:@"start_time"];
        self.place = [aDecoder decodeObjectForKey:@"place"];
        
    }
    return self;
}

- (id)valueForUndefinedKey:(NSString *)key
{
    // subclass implementation should provide correct key value mappings for custom keys
    DLog(@"Undefined Key: %@", key);
    if ([key isEqualToString:@"_id"]) {
        return self.itemId;
    }
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // subclass implementation should set the correct key value mappings for custom keys
    DLog(@"Undefined Key: %@", key);
    if ([key isEqualToString:@"_id"]) {
        self.itemId = value;
    }

}

@end
