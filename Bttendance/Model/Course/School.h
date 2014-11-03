//
//  School.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"

#define SCHOOL_TYPE_UNIVERSITY @"university"
#define SCHOOL_TYPE_SCHOOL @"school"
#define SCHOOL_TYPE_INSTITUTE @"institute"
#define SCHOOL_TYPE_ETC @"etc"

@interface School : BTObject

@property NSString          *name;
@property NSString          *type;
@property NSInteger         courses_count;
@property NSInteger         professors_count;
@property NSInteger         students_count;

@end
