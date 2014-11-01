//
//  Attendance.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"

@class SimplePost;

@interface Attendance : BTObject

@property NSString          *type;
@property NSData            *checked_students;
@property NSData            *late_students;
@property NSData            *clusters;
@property SimplePost        *post;

@end
