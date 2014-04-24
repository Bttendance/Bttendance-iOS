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

@class User;
@class Course;
@class Attendance;
@class Clicker;

@interface Post : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSString  *type;
@property(strong, nonatomic) NSString  *message;
@property(strong, nonatomic) User  *author;
@property(strong, nonatomic) Course  *course;
@property(strong, nonatomic) Attendance  *attendance;
@property(strong, nonatomic) Clicker  *clicker;

@property(strong, nonatomic) NSString  *grade;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
