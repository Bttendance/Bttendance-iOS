//
//  Setting.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "User.h"

@class SimpleUser;

@interface SimpleSetting : RLMObject

@property NSInteger         id;
@property BOOL              attendance;
@property BOOL              clicker;
@property BOOL              notice;
@property BOOL              curious;
@property NSInteger         progress_time;
@property BOOL              show_info_on_select;
@property NSString          *detail_privacy;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface Setting : RLMObject

@property NSInteger         id;
@property NSDate            *createdAt;
@property NSDate            *updatedAt;
@property BOOL              attendance;
@property BOOL              clicker;
@property BOOL              notice;
@property BOOL              curious;
@property NSInteger         progress_time;
@property BOOL              show_info_on_select;
@property NSString          *detail_privacy;
@property SimpleUser        *owner;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
