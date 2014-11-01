//
//  Device.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"

@class SimpleUser;

@interface Device : BTObject

@property NSString          *type;
@property NSString          *uuid;
@property NSString          *mac_address;
@property NSString          *notification_key;
@property SimpleUser        *owner;

@end
