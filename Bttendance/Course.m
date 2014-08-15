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

+ (NSDictionary *)toDictionary:(SimpleCourse *)course {
    
    NSMutableArray *keys = [NSMutableArray array];
    [keys addObject:@"id"];
    if (course.name != nil)
        [keys addObject:@"name"];
    if (course.professor_name != nil)
        [keys addObject:@"professor_name"];
    [keys addObject:@"school"];
    [keys addObject:@"opened"];
    
    NSMutableArray *objects = [NSMutableArray array];
    [objects addObject:[NSString stringWithFormat:@"%ld", (long)course.id]];
    if (course.name != nil)
        [objects addObject:course.name];
    if (course.professor_name != nil)
        [objects addObject:course.professor_name];
    [objects addObject:[NSString stringWithFormat:@"%ld", (long)course.school]];
    [objects addObject:course.opened? @"true" : @"false"];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    return dictionary;
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

        NSMutableArray *managers = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"managers"]) {
            SimpleUser *manager = [[SimpleUser alloc] initWithDictionary:dic];
            [managers addObject:manager];
        }
        self.managers = managers;
        
        self.students_count = [[dictionary objectForKey:@"students_count"] integerValue];
        self.posts_count = [[dictionary objectForKey:@"posts_count"] integerValue];
        self.code = [dictionary objectForKey:@"code"];
        self.opened = [[dictionary objectForKey:@"opened"] boolValue];
        
        //Added by APIs
        self.attendance_rate = [[dictionary objectForKey:@"attendance_rate"] integerValue];
        self.clicker_rate = [[dictionary objectForKey:@"clicker_rate"] integerValue];
        self.notice_unseen = [[dictionary objectForKey:@"notice_unseen"] integerValue];
    }
    return self;
}

@end
