//
//  JSONController.m
//  Bttendance
//
//  Created by HAJE on 2013. 12. 26..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "JSONController.h"
#import <AFNetworking.h>

@implementation JSONController

+(void)UserJSONUpdateNotificationKey:(NSString *)username :(NSString *)password :(NSString *)device_uuid :(NSString *)device_token{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"device_uuid":device_uuid,
                             @"notification_key":device_token};
    [AFmanager PUT:@"http://www.bttendance.com/api/user/update/notification_key" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Notification Key Update success : %@", responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Notification Key Update fail %@", error);
    }];
    
    
}
//Device Token update

+(void)UserJSONUpdateProfileImage:(NSString *)username :(NSString *)password :(NSString *)device_uuid{
//    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *params = @{@"username":username,
//                             @"password":password,
//                             @"device_uuid":device_uuid};
}
//Profile Image update how!!!????

+(void)UserJSONUpdateEmail:(NSString *)username :(NSString *)password :(NSString *)device_uuid :(NSString *)email{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"device_uuid":device_uuid,
                             @"email":email};
    [AFmanager PUT:@"http://www.bttendance.com/api/user/update/email" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Email Update success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Email Update fail %@", error);
        
    }];

}
//Email update

+(void)UserJSONUpdateFullname:(NSString *)username :(NSString *)password :(NSString *)device_uuid :(NSString *)Fullname{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"device_uuid":device_uuid,
                             @"full_name":Fullname};
    [AFmanager PUT:@"http://www.bttendance.com/api/user/update/full_name" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Full name Update success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Full name Update fail %@", error);
        
    }];
}
//Fullname update

+(void)UserJSONJoinSchool:(NSString *)username :(NSString *)password :(NSString *)School_Id{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"school_id":School_Id};
    [AFmanager PUT:@"http://www.bttendance.com/api/user/join/school" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Email Update success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Email Update fail %@", error);
        
    }];
}
//Join School

+(void)UserJSONJoinCourse:(NSString *)username :(NSString *)password :(NSString *)Course_Id{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"course_id":Course_Id};
    [AFmanager PUT:@"http://www.bttendance.com/api/user/join/course" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Join Course success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Join Course fail %@", error);
    }];
     
}
//Join Course

+(void)SchoolJSONGetSchool:(NSString *)username :(NSString *)password{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password};
    [AFmanager GET:@"http://www.bttendance.com/api/user/schools" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Get Schools List success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Get Schools List fail %@", error);
    }];
}
//Get School list

+(void)CourseJSONGetCourse:(NSString *)username :(NSString *)password{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password};
    [AFmanager GET:@"http://www.bttendance.com/api/user/courses" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Get Courses List success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Get Courses List fail %@", error);
    }];
}
//Get Course list

+(void)CourseJSONGetJoinableCourse:(NSString *)username :(NSString *)password{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password};
    [AFmanager GET:@"http://www.bttendance.com/api/user/joinable/courses" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Get Joinable Courses List success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Get Joinable Courses List fail %@", error);
    }];
}
//Get joinable course list

+(void)PostJSONGetUserFeed:(NSString *)username :(NSString *)password :(NSString *)page{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"page":page};
    [AFmanager GET:@"http://www.bttendance.com/api/user/feed" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Get feed success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Get feed fail %@", error);
    }];
}
//Get User Feed

+(void)SchoolJSONCreateSchool:(NSString *)username :(NSString *)password :(NSString *)School_name :(NSString *)website{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"school_name":School_name,
                             @"website":website};
    [AFmanager POST:@"http://www.bttendance.com/api/school/create" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Create School success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Create School fail %@", error);
    }];
}
//Create School

+(void)CourseJSONCreateCourse:(NSString *)username :(NSString *)password :(NSString *)Course_name :(NSString *)number :(NSString *)School_Id{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"name":Course_name,
                             @"number":number,
                             @"school_id":School_Id};
    [AFmanager POST:@"http://www.bttendance.com/api/course/create" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Create Course success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Create Course fail %@", error);
    }];
}
//Create Course

+(void)PostJSONGetCourseFeed:(NSString *)username :(NSString *)password :(NSString *)Course_Id :(NSString *)page{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"course_id":Course_Id,
                             @"page":page};
    [AFmanager GET:@"http://www.bttendance.com/api/course/feed" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Get Courses feed success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Get Courses feed fail %@", error);
    }];
}
//Get Course Feed

+(void)PostJSONCreatePost:(NSString *)username :(NSString *)password :(NSString *)type :(NSString *)title :(NSString *)message :(NSString *)Course_Id{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"type":type,
                             @"title":title,
                             @"message":message,
                             @"course_id":Course_Id};
    [AFmanager POST:@"http://www.bttendance.com/api/post/create" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Create Post success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Create Post fail %@", error);
    }];
}
//Create Post

+(void)CourseJSONStartAttd:(NSString *)username :(NSString *)password :(NSString *)Course_Id{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"course_id":Course_Id};
    [AFmanager POST:@"http://www.bttendance.com/api/attendance/start" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Start Attendance success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Start Attendance fail %@", error);
    }];
}
//Start Course Attendance

+(void)PostJSONCheckAttd:(NSString *)username :(NSString *)password :(NSString *)post_Id :(NSString *)longitude :(NSString *)latitude :(NSString *)device_uuid{//should be change to string array or mutabletable
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"post_id":post_Id,
                             @"longitude":longitude,
                             @"latitude":latitude,
                             @"device_uuid":device_uuid};
    [AFmanager PUT:@"http://www.bttendance.com/api/attendance/check" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Attendance check success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Attendance check fail %@", error);
    }];
}
//Check Attendance

+(void)UserJSONGetStudentList:(NSString *)username :(NSString *)password :(NSString *)post_Id{
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"post_id":post_Id};
    [AFmanager GET:@"http://www.bttendance.com/api/post/student/list" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Get student List success : %@", responseObject);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Get student List fail %@", error);
    }];
}
//Get Student list

@end
