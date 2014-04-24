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

@implementation Course

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"updatedAt"]];
        self.name = [dictionary objectForKey:@"name"];
        self.number = [dictionary objectForKey:@"number"];
        self.professor_name = [dictionary objectForKey:@"professor_name"];
        self.school = [[School alloc] initWithDictionary:[dictionary objectForKey:@"school"]];
        
        NSMutableArray *managers = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"managers"]) {
            User *user = [[User alloc] initWithDictionary:dic];
            [managers addObject:user];
        }
        self.managers = managers;
        
        NSMutableArray *students = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"students"]) {
            User *user = [[User alloc] initWithDictionary:dic];
            [students addObject:user];
        }
        self.students = students;
        
        NSMutableArray *posts = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"posts"]) {
            Post *post = [[Post alloc] initWithDictionary:dic];
            [posts addObject:post];
        }
        self.posts = posts;
        
        self.students_count = [[dictionary objectForKey:@"students_count"] integerValue];
        self.attdCheckedAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"attdCheckedAt"]];
        self.clicker_usage = [[dictionary objectForKey:@"clicker_usage"] integerValue];
        self.notice_usage = [[dictionary objectForKey:@"notice_usage"] integerValue];
        
        self.grade = [dictionary objectForKey:@"grade"];
    }
    return self;
}

@end
