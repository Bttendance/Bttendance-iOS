//
//  JSONController.h
//  Bttendance
//
//  Created by HAJE on 2013. 12. 26..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONController : NSObject

+(void)UserJSONUpdateNotificationKey:(NSString *)username :(NSString *)password :(NSString *)device_uuid :(NSString *)device_token;
//Device Token update

+(void)UserJSONUpdateProfileImage:(NSString *)username :(NSString *)password :(NSString *)device_uuid;
//Profile Image update

+(void)UserJSONUpdateEmail:(NSString *)username :(NSString *)password :(NSString *)device_uuid :(NSString *)email;
//Email update

+(void)UserJSONUpdateFullname:(NSString *)username :(NSString *)password :(NSString *)device_uuid :(NSString *)Fullname;
//Fullname update

+(void)UserJSONJoinSchool:(NSString *)username :(NSString *)password :(NSString *)School_Id;
//Join School

+(void)UserJSONJoinCourse:(NSString *)username :(NSString *)password :(NSString *)Course_Id;
//Join Course

+(void)SchoolJSONGetSchool:(NSString *)username :(NSString *)password ;
//Get School list

+(void)CourseJSONGetCourse:(NSString *)username :(NSString *)password ;
//Get Course list

+(void)CourseJSONGetJoinableCourse:(NSString *)username :(NSString *)password ;
//Get joinable course list

+(void)PostJSONGetUserFeed:(NSString *)username :(NSString *)password :(NSString *)page;
//Get User Feed

+(void)SchoolJSONCreateSchool:(NSString *)username :(NSString *)password :(NSString *)School_name :(NSString *)website;
//Create School

+(void)CourseJSONCreateCourse:(NSString *)username :(NSString *)password :(NSString *)Course_name :(NSString *)number :(NSString *)School_Id;
//Create Course

+(void)PostJSONGetCourseFeed:(NSString *)username :(NSString *)password :(NSString *)Course_Id :(NSString *)page;
//Get Course Feed

+(void)PostJSONCreatePost:(NSString *)username :(NSString *)password :(NSString *)type :(NSString *)title :(NSString *)message :(NSString *)Course_Id;
//Create Post

+(void)CourseJSONStartAttd:(NSString *)username :(NSString *)password :(NSString *)Course_Id;
//Start Course Attendance

+(void)PostJSONCheckAttd:(NSString *)username :(NSString *)password :(NSString *)post_Id :(NSString *)longitude :(NSString *)latitude :(NSString *)device_uuid;//should be change to string array or mutabletable
//Check Attendance

+(void)UserJSONGetStudentList:(NSString *)username :(NSString *)password :(NSString *)post_Id;
//Get Student list


@end
