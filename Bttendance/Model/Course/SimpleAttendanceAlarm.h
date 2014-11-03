//
//  SimpleAttendanceAlarm.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTSimpleObject.h"

@interface SimpleAttendanceAlarm : BTSimpleObject

@property NSString          *type;
@property NSString          *scheduledAt;
@property BOOL              on;
@property NSInteger         author;

@end
RLM_ARRAY_TYPE(SimpleAttendanceAlarm)
