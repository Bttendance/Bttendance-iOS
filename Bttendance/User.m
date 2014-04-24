//
//  User.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [dictionary objectForKey:@"createdAt"];
        self.updatedAt = [dictionary objectForKey:@"updatedAt"];
        self.username = [dictionary objectForKey:@"username"];
        self.email = [dictionary objectForKey:@"email"];
        self.password = [dictionary objectForKey:@"password"];
        self.full_name = [dictionary objectForKey:@"full_name"];
        self.profile_image = [dictionary objectForKey:@"profile_image"];
    }
    return self;
}

@end
