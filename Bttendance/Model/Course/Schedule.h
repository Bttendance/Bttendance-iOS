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

#define SCHEDULE_WEEKDAY_SUN @"Sun"
#define SCHEDULE_WEEKDAY_MON @"Mon"
#define SCHEDULE_WEEKDAY_TUE @"Tue"
#define SCHEDULE_WEEKDAY_WED @"Wed"
#define SCHEDULE_WEEKDAY_THU @"Thu"
#define SCHEDULE_WEEKDAY_FRI @"Fri"
#define SCHEDULE_WEEKDAY_SAT @"Sat"

@interface Schedule : BTObject

@property SimpleCourse                      *course;
@property NSString                          *weekday;
@property NSString                          *time;
@property NSString                          *timezone;
@property RLMArray<SimpleAttendanceAlarm>   *alarms;

@end
