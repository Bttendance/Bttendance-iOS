//
//  Post.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Post.h"
#import "BTDateFormatter.h"

@implementation Post

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"updatedAt"]];
        self.type = [dictionary objectForKey:@"type"];
        self.message = [dictionary objectForKey:@"message"];
        self.author = [[User alloc] initWithDictionary:[dictionary objectForKey:@"author"]];
        self.course = [[Course alloc] initWithDictionary:[dictionary objectForKey:@"course"]];
        self.attendance = [[Attendance alloc] initWithDictionary:[dictionary objectForKey:@"attendance"]];
        self.clicker = [[Clicker alloc] initWithDictionary:[dictionary objectForKey:@"clicker"]];
        
        self.grade = [dictionary objectForKey:@"grade"];
    }
    return self;
}

@end
