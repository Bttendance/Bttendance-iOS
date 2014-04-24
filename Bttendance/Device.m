//
//  Device.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Device.h"
#import "BTDateFormatter.h"

@implementation Device

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromUTC:[dictionary objectForKey:@"updatedAt"]];
        self.type = [dictionary objectForKey:@"type"];
        self.uuid = [dictionary objectForKey:@"uuid"];
        self.mac_address = [dictionary objectForKey:@"mac_address"];
        self.notification_key = [dictionary objectForKey:@"notification_key"];
        self.owner = [[User alloc] initWithDictionary:[dictionary objectForKey:@"owner"]];
    }
    return self;
}

@end
