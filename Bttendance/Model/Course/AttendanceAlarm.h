//
//  AttendanceAlarm.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "SimpleUser.h"
#import "SimpleCourse.h"
#import "SimpleSchedule.h"

@interface AttendanceAlarm : BTObject

@property NSString          *type;
@property NSString          *scheduledAt;
@property BOOL              on;
@property SimpleUser        *author;
@property SimpleCourse      *course;
@property SimpleSchedule    *schedule;

@end
