//
//  Post.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Post.h"
#import "BTDateFormatter.h"
#import "NSDictionary+Bttendance.h"

@implementation SimplePost

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.type = [dictionary objectForKey:@"type"];
        self.message = [dictionary objectForKey:@"message"];
        self.author = [[dictionary objectForKey:@"author"] integerValue];
        self.course = [[dictionary objectForKey:@"course"] integerValue];
    }
    return self;
}

@end

@implementation Post

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.type = [dictionary objectForKey:@"type"];
        self.message = [dictionary objectForKey:@"message"];
        self.author = [[SimpleUser alloc] initWithDictionary:[dictionary objectForKey:@"author"]];
        self.course = [[SimpleCourse alloc] initWithDictionary:[dictionary objectForKey:@"course"]];
        self.attendance = [[SimpleAttendance alloc] initWithDictionary:[dictionary objectForKey:@"attendance"]];
        self.clicker = [[SimpleClicker alloc] initWithDictionary:[dictionary objectForKey:@"clicker"]];
        self.notice = [[SimpleNotice alloc] initWithDictionary:[dictionary objectForKey:@"notice"]];
        
        //Added by APIs
        self.grade = [dictionary objectForKey:@"grade"];
    }
    return self;
}

@end
