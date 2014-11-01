//
//  CourseSimple.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObjectSimple.h"

@interface CourseSimple : BTObjectSimple

@property NSString          *name;
@property NSString          *professor_name;
@property NSInteger         school;
@property BOOL              opened;

@end
RLM_ARRAY_TYPE(CourseSimple)
