//
//  Post.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "SimpleUser.h"
#import "SimpleCourse.h"
#import "SimpleAttendance.h"
#import "SimpleClicker.h"
#import "SimpleNotice.h"
#import "SimpleCurious.h"

#define POST_TYPE_ATTENDANCE @"attendance"
#define POST_TYPE_NOTICE @"notice"
#define POST_TYPE_CLICKER @"clicker"
#define POST_TYPE_CURIOUS @"curious"

@interface Post : BTObject

@property NSString          *type;
@property NSString          *message;
@property SimpleUser        *author;
@property SimpleCourse      *course;
@property SimpleAttendance  *attendance;
@property SimpleClicker     *clicker;
@property SimpleNotice      *notice;
@property SimpleCurious     *curious;
@property NSData            *seen_managers;
@property NSData            *seen_students;
@property NSInteger         comments_count;



- (NSArray *)seenManagers;
- (NSArray *)seenStudents;

- (NSInteger)seenManagersCount;
- (NSInteger)seenStudentsCount;

- (NSTimeInterval) createdDateTimeInterval;

- (NSString *) createdDatePostFormat;
- (NSString *) createdDateWholeFormat;
- (NSString *) createdDateDateFormat;
- (NSString *) createdDateTimeFormat;

@end
