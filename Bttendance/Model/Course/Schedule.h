//
//  Schedule.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "RLMArray.h"
#import "SimpleCourse.h"
#import "SimpleAttendanceAlarm.h"

@interface Schedule : BTObject

@property SimpleCourse                      *course;
@property NSString                          *weekday;
@property NSString                          *time;
@property NSString                          *timezone;
@property RLMArray<SimpleAttendanceAlarm>   *alarms;

@end
