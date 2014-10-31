//
//  Device.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "User.h"

@class SimpleUser;

@interface SimpleDevice : RLMObject

@property NSInteger         id;
@property NSString          *type;
@property NSString          *uuid;
@property NSString          *notification_key;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface Device : RLMObject

@property NSInteger         id;
@property NSDate            *createdAt;
@property NSDate            *updatedAt;
@property NSString          *type;
@property NSString          *uuid;
@property NSString          *mac_address;
@property NSString          *notification_key;
@property SimpleUser        *owner;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
