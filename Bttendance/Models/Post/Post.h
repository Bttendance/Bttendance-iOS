//
//  Post.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"

@class SimpleUser;
@class SimpleCourse;
@class SimpleAttendance;
@class SimpleClicker;
@class SimpleNotice;

@interface Post : BTObject

@property NSString          *type;
@property NSString          *message;
@property SimpleUser        *author;
@property SimpleCourse      *course;
@property SimpleAttendance  *attendance;
@property SimpleClicker     *clicker;
@property SimpleNotice      *notice;

@end
