//
//  Setting.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class SimpleUser;

@interface SimpleSetting : NSObject

@property(assign) NSInteger id;
@property(assign) BOOL attendance;
@property(assign) BOOL clicker;
@property(assign) BOOL notice;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface Setting : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(assign) BOOL attendance;
@property(assign) BOOL clicker;
@property(assign) BOOL notice;
@property(strong, nonatomic) SimpleUser  *owner;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
