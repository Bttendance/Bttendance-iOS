//
//  Identification.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Identification.h"
#import "BTDateFormatter.h"

@implementation Identification

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"updatedAt"]];
        self.identity = [dictionary objectForKey:@"identity"];
        self.owner = [[User alloc] initWithDictionary:[dictionary objectForKey:@"owner"]];
        self.school = [[School alloc] initWithDictionary:[dictionary objectForKey:@"school"]];
    }
    return self;
}

@end
