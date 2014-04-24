//
//  Serial.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Serial.h"
#import "BTDateFormatter.h"
#import "User.h"

@implementation Serial

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"updatedAt"]];
        self.key = [dictionary objectForKey:@"key"];
        self.school = [[School alloc] initWithDictionary:[dictionary objectForKey:@"school"]];
        
        NSMutableArray *owners = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"owners"]) {
            User *user = [[User alloc] initWithDictionary:dic];
            [owners addObject:user];
        }
        self.owners = owners;
    }
    return self;
}

@end
