//
//  PushNoti.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "PushNoti.h"

@implementation PushNoti

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.type = [dictionary objectForKey:@"type"];
        self.course_id = [dictionary objectForKey:@"course_id"];
        self.title = [dictionary objectForKey:@"title"];
        self.message = [dictionary objectForKey:@"message"];
    }
    return self;
}

@end