//
//  Notification.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Notification.h"
#import "BTDateFormatter.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleNotification

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.attendance = [[dictionary objectForKey:@"attendance"] boolValue];
        self.clicker = [[dictionary objectForKey:@"clicker"] boolValue];
        self.notice = [[dictionary objectForKey:@"notice"] boolValue];
    }
    return self;
}

@end


@implementation Notification

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.attendance = [[dictionary objectForKey:@"attendance"] boolValue];
        self.clicker = [[dictionary objectForKey:@"clicker"] boolValue];
        self.notice = [[dictionary objectForKey:@"notice"] boolValue];
        self.owner = [[SimpleUser alloc] initWithDictionary:[dictionary objectForKey:@"owner"]];
    }
    return self;
}
@end
