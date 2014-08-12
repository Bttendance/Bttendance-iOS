//
//  Post.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
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

@interface SimplePost : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSString  *type;
@property(strong, nonatomic) NSString  *message;
@property(assign) NSInteger  author;
@property(assign) NSInteger  course;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface Post : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSString  *type;
@property(strong, nonatomic) NSString  *message;
@property(strong, nonatomic) SimpleUser  *author;
@property(strong, nonatomic) SimpleCourse  *course;
@property(strong, nonatomic) SimpleAttendance  *attendance;
@property(strong, nonatomic) SimpleClicker  *clicker;
@property(strong, nonatomic) SimpleNotice  *notice;

//Added by APIs
@property(strong, nonatomic) NSString  *grade;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSDictionary *)toDictionary:(Post *)post;

@end
