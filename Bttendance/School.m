//
//  School.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "School.h"
#import "BTDateFormatter.h"
#import "Serial.h"
#import "Course.h"
#import "User.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleSchool

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.name = [dictionary objectForKey:@"name"];
        self.logo_image = [dictionary objectForKey:@"logo_image"];
        self.website = [NSURL URLWithString:[[dictionary objectForKey:@"website"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        self.type = [dictionary objectForKey:@"type"];
    }
    return self;
}

@end

@implementation School

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.name = [dictionary objectForKey:@"name"];
        self.logo_image = [dictionary objectForKey:@"logo_image"];
        self.website = [NSURL URLWithString:[[dictionary objectForKey:@"website"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        self.type = [dictionary objectForKey:@"type"];
        
        NSMutableArray *serials = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"serials"]) {
            SimpleSerial *serial = [[SimpleSerial alloc] initWithDictionary:dic];
            [serials addObject:serial];
        }
        self.serials = serials;
        
        NSMutableArray *courses = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"courses"]) {
            SimpleCourse *course = [[SimpleCourse alloc] initWithDictionary:dic];
            [courses addObject:course];
        }
        self.courses = courses;
        
        NSMutableArray *professors = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"professors"]) {
            SimpleUser *user = [[SimpleUser alloc] initWithDictionary:dic];
            [professors addObject:user];
        }
        self.professors = professors;
        
        NSMutableArray *students = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"students"]) {
            SimpleUser *user = [[SimpleUser alloc] initWithDictionary:dic];
            [students addObject:user];
        }
        self.students = students;
    }
    return self;
}

@end
