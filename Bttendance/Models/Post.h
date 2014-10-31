//
//  Post.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "User.h"
#import "Course.h"
#import "Attendance.h"
#import "Clicker.h"
#import "Notice.h"

@class SimpleUser;
@class SimpleCourse;
@class SimpleAttendance;
@class SimpleClicker;
@class SimpleNotice;

@interface SimplePost : RLMObject

@property NSInteger         id;
@property NSString          *type;
@property NSString          *message;
@property NSInteger         author;
@property NSInteger         course;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface Post : RLMObject

@property NSInteger         id;
@property NSDate            *createdAt;
@property NSDate            *updatedAt;
@property NSString          *type;
@property NSString          *message;
@property SimpleUser        *author;
@property SimpleCourse      *course;
@property SimpleAttendance  *attendance;
@property SimpleClicker     *clicker;
@property SimpleNotice      *notice;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSDictionary *)toDictionary:(Post *)post;

@end
