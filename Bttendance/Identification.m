//
//  Identification.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Identification.h"
#import "BTDateFormatter.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleIdentification

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.identity = [dictionary objectForKey:@"identity"];
        self.school = [[dictionary objectForKey:@"school"] integerValue];
    }
    return self;
}

@end


@implementation Identification

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.identity = [dictionary objectForKey:@"identity"];
        self.owner = [[SimpleUser alloc] initWithDictionary:[dictionary objectForKey:@"owner"]];
        self.school = [[SimpleSchool alloc] initWithDictionary:[dictionary objectForKey:@"school"]];
    }
    return self;
}

@end
