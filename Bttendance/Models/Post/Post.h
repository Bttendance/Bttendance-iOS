//
//  Post.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "SimpleUser.h"
#import "SimpleCourse.h"
#import "SimpleAttendance.h"
#import "SimpleClicker.h"
#import "SimpleNotice.h"

@interface Post : BTObject

@property NSString          *type;
@property NSString          *message;
@property SimpleUser        *author;
@property SimpleCourse      *course;
@property SimpleAttendance  *attendance;
@property SimpleClicker     *clicker;
@property SimpleNotice      *notice;

@end
