//
//  SimpleSchedule.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTSimpleObject.h"

@interface SimpleSchedule : BTSimpleObject

@property NSInteger             course;
@property NSString              *weekday;
@property NSString              *time;
@property NSString              *timezone;

@end
RLM_ARRAY_TYPE(SimpleSchedule)
