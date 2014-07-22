//
//  Notice.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Notice.h"
#import "BTDateFormatter.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleNotice

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.seen_students = [dictionary objectForKey:@"seen_students"];
        self.post = [[dictionary objectForKey:@"post"] integerValue];
    }
    return self;
}

@end


@implementation Notice

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.seen_students = [dictionary objectForKey:@"seen_students"];
        self.post = [[SimplePost alloc] initWithDictionary:[dictionary objectForKey:@"post"]];
    }
    return self;
}

@end
