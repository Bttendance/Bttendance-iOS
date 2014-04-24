//
//  Notification.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Notification.h"

@implementation Notification

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.type = [dictionary objectForKey:@"type"];
        self.title = [dictionary objectForKey:@"title"];
        self.message = [dictionary objectForKey:@"message"];
    }
    return self;
}

@end
