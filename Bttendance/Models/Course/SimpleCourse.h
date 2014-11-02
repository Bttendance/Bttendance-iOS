//
//  SimpleCourse.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObjectSimple.h"

@interface SimpleCourse : BTObjectSimple

@property NSString          *name;
@property NSString          *professor_name;
@property NSInteger         school;
@property NSString          *code;
@property BOOL              opened;

@end
RLM_ARRAY_TYPE(SimpleCourse)
