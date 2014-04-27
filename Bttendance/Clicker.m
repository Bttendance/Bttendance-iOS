//
//  Clicker.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Clicker.h"
#import "BTDateFormatter.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleClicker

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.choice_count = [[dictionary objectForKey:@"choice_count"] integerValue];
        self.a_students = [dictionary objectForKey:@"a_students"];
        self.b_students = [dictionary objectForKey:@"b_students"];
        self.c_students = [dictionary objectForKey:@"c_students"];
        self.d_students = [dictionary objectForKey:@"d_students"];
        self.e_students = [dictionary objectForKey:@"e_students"];
        self.post = [[dictionary objectForKey:@"post"] integerValue];
    }
    return self;
}

@end


@implementation Clicker

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.choice_count = [[dictionary objectForKey:@"choice_count"] integerValue];
        self.a_students = [dictionary objectForKey:@"a_students"];
        self.b_students = [dictionary objectForKey:@"b_students"];
        self.c_students = [dictionary objectForKey:@"c_students"];
        self.d_students = [dictionary objectForKey:@"d_students"];
        self.e_students = [dictionary objectForKey:@"e_students"];
        self.post = [[SimplePost alloc] initWithDictionary:[dictionary objectForKey:@"post"]];
    }
    return self;
}

@end
