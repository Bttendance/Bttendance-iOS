//
//  Clicker.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Clicker.h"
#import "BTDateFormatter.h"

@implementation Clicker

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"updatedAt"]];
        self.choice_count = [[dictionary objectForKey:@"choice_count"] integerValue];
        
        NSMutableArray *a_students = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"a_students"]) {
            User *user = [[User alloc] initWithDictionary:dic];
            [a_students addObject:user];
        }
        self.a_students = a_students;
        
        NSMutableArray *b_students = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"b_students"]) {
            User *user = [[User alloc] initWithDictionary:dic];
            [b_students addObject:user];
        }
        self.b_students = b_students;
        
        NSMutableArray *c_students = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"c_students"]) {
            User *user = [[User alloc] initWithDictionary:dic];
            [c_students addObject:user];
        }
        self.c_students = c_students;
        
        NSMutableArray *d_students = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"d_students"]) {
            User *user = [[User alloc] initWithDictionary:dic];
            [d_students addObject:user];
        }
        self.d_students = d_students;
        
        NSMutableArray *e_students = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"e_students"]) {
            User *user = [[User alloc] initWithDictionary:dic];
            [e_students addObject:user];
        }
        self.e_students = e_students;
        
        self.post = [[Post alloc] initWithDictionary:[dictionary objectForKey:@"post"]];
    }
    return self;
}

@end
