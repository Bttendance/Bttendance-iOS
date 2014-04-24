//
//  Attendance.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Attendance.h"
#import "BTDateFormatter.h"

@implementation Attendance

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"updatedAt"]];
        self.checked_students = [dictionary objectForKey:@"checked_students"];
        self.clusters = [dictionary objectForKey:@"clusters"];
        self.post = [[Post alloc] initWithDictionary:[dictionary objectForKey:@"post"]];
    }
    return self;
}

@end
