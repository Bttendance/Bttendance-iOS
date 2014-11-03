//
//  Setting.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "SimpleUser.h"

@interface Setting : BTObject

@property BOOL              attendance;
@property BOOL              clicker;
@property BOOL              notice;
@property BOOL              curious;
@property SimpleUser        *owner;

@end
