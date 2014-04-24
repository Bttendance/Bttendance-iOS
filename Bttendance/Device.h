//
//  Device.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class User;

@interface Device : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSString  *type;
@property(strong, nonatomic) NSString  *uuid;
@property(strong, nonatomic) NSString  *mac_address;
@property(strong, nonatomic) NSString  *notification_key;
@property(strong, nonatomic) User  *owner;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
