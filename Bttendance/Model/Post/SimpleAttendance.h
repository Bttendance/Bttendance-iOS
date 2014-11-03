//
//  SimpleAttendance.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"

@interface SimpleAttendance : BTObject

@property NSString          *type;
@property NSData            *checked_students;
@property NSData            *late_students;
@property NSInteger         post;

- (void)copyDataFromAttendance:(id)object;

- (NSInteger)stateInt:(NSInteger)userId;
- (void)toggleStatus:(NSInteger)userId;

- (NSArray *)checkedStudents;
- (NSArray *)lateStudents;

- (NSInteger)checkedStudentsCount;
- (NSInteger)lateStudentsCount;

- (NSInteger)totalStudentsCount;

@end
