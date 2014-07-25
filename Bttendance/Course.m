//
//  Course.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Course.h"
#import "BTDateFormatter.h"
#import "User.h"
#import "Post.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleCourse

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.name = [dictionary objectForKey:@"name"];
        self.professor_name = [dictionary objectForKey:@"professor_name"];
        self.school = [[dictionary objectForKey:@"school"] integerValue];
        self.opened = [[dictionary objectForKey:@"opened"] boolValue];
    }
    return self;
}

@end


@implementation Course

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.name = [dictionary objectForKey:@"name"];
        self.professor_name = [dictionary objectForKey:@"professor_name"];
        self.school = [[SimpleSchool alloc] initWithDictionary:[dictionary objectForKey:@"school"]];
        self.managers_count = [[dictionary objectForKey:@"managers_count"] integerValue];
        self.students_count = [[dictionary objectForKey:@"students_count"] integerValue];
        self.posts_count = [[dictionary objectForKey:@"posts_count"] integerValue];
        self.code = [dictionary objectForKey:@"code"];
        self.opened = [[dictionary objectForKey:@"opened"] boolValue];
        
        //Added by APIs
        self.attendance_rate = [dictionary objectForKey:@"attendance_rate"];
        self.clicker_rate = [dictionary objectForKey:@"clicker_rate"];
        self.notice_unseen = [dictionary objectForKey:@"notice_unseen"];
    }
    return self;
}

@end
