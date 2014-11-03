//
//  Device.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "SimpleUser.h"

#define DEVICE_TYPE_IPHONE @"iphone"
#define DEVICE_TYPE_ANDROID @"android"
#define DEVICE_TYPE_XIAOMI @"xiaomi"

@interface Device : BTObject

@property NSString          *type;
@property NSString          *uuid;
@property NSString          *mac_address;
@property NSString          *notification_key;
@property SimpleUser        *owner;

@end
