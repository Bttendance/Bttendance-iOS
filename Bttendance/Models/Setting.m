//
//  Setting.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Setting.h"
#import "NSDate+Bttendance.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleSetting

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.attendance = [[dictionary objectForKey:@"attendance"] boolValue];
        self.clicker = [[dictionary objectForKey:@"clicker"] boolValue];
        self.notice = [[dictionary objectForKey:@"notice"] boolValue];
        self.progress_time = [[dictionary objectForKey:@"progress_time"] integerValue];
        self.show_info_on_select = [[dictionary objectForKey:@"show_info_on_select"] boolValue];
        self.detail_privacy = [dictionary objectForKey:@"detail_privacy"];
    }
    return self;
}

@end


@implementation Setting

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [NSDate dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [NSDate dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.attendance = [[dictionary objectForKey:@"attendance"] boolValue];
        self.clicker = [[dictionary objectForKey:@"clicker"] boolValue];
        self.notice = [[dictionary objectForKey:@"notice"] boolValue];
        self.progress_time = [[dictionary objectForKey:@"progress_time"] integerValue];
        self.show_info_on_select = [[dictionary objectForKey:@"show_info_on_select"] boolValue];
        self.detail_privacy = [dictionary objectForKey:@"detail_privacy"];
        self.owner = [[SimpleUser alloc] initWithDictionary:[dictionary objectForKey:@"owner"]];
    }
    return self;
}
@end
