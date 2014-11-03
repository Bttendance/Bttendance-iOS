//
//  BTTable.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Course.h"
#import "Post.h"
#import "Clicker.h"
#import "Attendance.h"
#import "Notice.h"

@interface BTTable : NSObject

+ (User *)getUser;

+ (void)setUser:(id)responseObject;

+ (NSArray *)getCourses;

+ (Course *)getCourse:(NSInteger)courseId;

+ (void)setCourse:(id)responseObject ofCourse:(NSString *)courseId;

+ (void)setCourses:(id)responseObject;

+ (NSArray *)getPostsOfArray:(NSString *)courseId;

+ (void)setPostsArray:(id)responseObject ofCourse:(NSString *)courseId;

+ (void)updateClicker:(Clicker *)clicker ofCourse:(NSString *)courseId;

+ (void)updateAttendance:(Attendance *)attendance ofCourse:(NSString *)courseId;

+ (void)updateNotice:(Notice *)notice ofCourse:(NSString *)courseId;

+ (void)updatePost:(Post *)newPost ofCourse:(NSString *)courseId;

+ (NSArray *)getSchools;

+ (void)setSchools:(id)responseObject;

+ (NSArray *)getStudentsOfArray:(NSString *)courseId;

+ (void)setStudentsArray:(id)responseObject ofCourse:(NSString *)courseId;

+ (NSArray *)getQuestions;

+ (void)setQuestions:(id)responseObject;

@end
