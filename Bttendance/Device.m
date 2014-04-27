//
//  Device.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Device.h"
#import "BTDateFormatter.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleDevice

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.type = [dictionary objectForKey:@"type"];
        self.uuid = [dictionary objectForKey:@"uuid"];
        self.notification_key = [dictionary objectForKey:@"notification_key"];
    }
    return self;
}

@end


@implementation Device

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.type = [dictionary objectForKey:@"type"];
        self.uuid = [dictionary objectForKey:@"uuid"];
        self.mac_address = [dictionary objectForKey:@"mac_address"];
        self.notification_key = [dictionary objectForKey:@"notification_key"];
        self.owner = [[SimpleUser alloc] initWithDictionary:[dictionary objectForKey:@"owner"]];
    }
    return self;
}

@end
