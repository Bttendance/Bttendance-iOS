//
//  User.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "User.h"
#import "BTDateFormatter.h"
#import "Course.h"
#import "School.h"
#import "Serial.h"
#import "Identification.h"

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"updatedAt"]];
        self.username = [dictionary objectForKey:@"username"];
        self.email = [dictionary objectForKey:@"email"];
        self.password = [dictionary objectForKey:@"password"];
        self.full_name = [dictionary objectForKey:@"full_name"];
        self.profile_image = [NSURL URLWithString:[[dictionary objectForKey:@"profile_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        self.device = [[Device alloc] initWithDictionary:[dictionary objectForKey:@"device"]];
        
        NSMutableArray *supervising_courses = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"supervising_courses"]) {
            Course *course = [[Course alloc] initWithDictionary:dic];
            [supervising_courses addObject:course];
        }
        self.supervising_courses = supervising_courses;
        
        NSMutableArray *attending_courses = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"attending_courses"]) {
            Course *course = [[Course alloc] initWithDictionary:dic];
            [attending_courses addObject:course];
        }
        self.attending_courses = attending_courses;
        
        NSMutableArray *employed_schools = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"employed_schools"]) {
            School *school = [[School alloc] initWithDictionary:dic];
            [employed_schools addObject:school];
        }
        self.employed_schools = employed_schools;
        
        NSMutableArray *serials = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"serials"]) {
            Serial *serial = [[Serial alloc] initWithDictionary:dic];
            [serials addObject:serials];
        }
        self.serials = serials;
        
        NSMutableArray *enrolled_schools = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"enrolled_schools"]) {
            School *school = [[School alloc] initWithDictionary:dic];
            [enrolled_schools addObject:school];
        }
        self.enrolled_schools = enrolled_schools;
        
        NSMutableArray *identifications = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"identifications"]) {
            Identification *identification = [[Identification alloc] initWithDictionary:dic];
            [identifications addObject:identification];
        }
        self.identifications = identifications;
    }
    return self;
}

@end
