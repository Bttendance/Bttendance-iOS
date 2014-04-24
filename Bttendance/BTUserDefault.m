//
//  BTUserDefault.m
//  Bttendance
//
//  Created by H AJE on 2013. 11. 9..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "BTUserDefault.h"

@implementation BTUserDefault

+ (NSDictionary *)getUserInfo {
    NSString *uuid = [[NSUserDefaults standardUserDefaults] stringForKey:UUIDKey];
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:UsernameKey];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:PasswordKey];
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UseridKey];
    NSString *fullname = [[NSUserDefaults standardUserDefaults] stringForKey:FullNameKey];
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:EmailKey];
    NSArray *attendingCourses = [[NSUserDefaults standardUserDefaults] arrayForKey:AttendingCoursesKey];
    NSArray *supervisingCourses = [[NSUserDefaults standardUserDefaults] arrayForKey:SupervisingCoursesKey];
    NSArray *employedSchools = [[NSUserDefaults standardUserDefaults] arrayForKey:EmployedSchoolsKey];
    NSArray *enrolledSchools = [[NSUserDefaults standardUserDefaults] arrayForKey:EnrolledSchoolsKey];

    NSDictionary *user_info = @{UsernameKey : username, PasswordKey : password, UUIDKey : uuid, UseridKey : userid,
            FullNameKey : fullname, EmailKey : email, AttendingCoursesKey : attendingCourses,
            SupervisingCoursesKey : supervisingCourses, EmployedSchoolsKey : employedSchools,
            EnrolledSchoolsKey : enrolledSchools};

    return user_info;
}

+ (void)setUserInfo:(id)responseObject {
    NSString *username = [responseObject objectForKey:@"username"];
    NSString *password = [responseObject objectForKey:@"password"];
    NSString *userid = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"id"]];
    NSString *fullname = [responseObject objectForKey:@"full_name"];
    NSString *email = [responseObject objectForKey:@"email"];
    NSArray *attendingCourses = [responseObject objectForKey:@"attending_courses"];
    NSArray *supervisingCourses = [responseObject objectForKey:@"supervising_courses"];
    NSArray *employedSchools = [responseObject objectForKey:@"employed_schools"];
    NSArray *enrolledSchools = [responseObject objectForKey:@"enrolled_schools"];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithString:username] forKey:UsernameKey];
    [defaults setObject:[NSString stringWithString:password] forKey:PasswordKey];
    [defaults setObject:[NSString stringWithString:userid] forKey:UseridKey];
    [defaults setObject:[NSString stringWithString:fullname] forKey:FullNameKey];
    [defaults setObject:[NSString stringWithString:email] forKey:EmailKey];
    [defaults setObject:[NSArray arrayWithArray:attendingCourses] forKey:AttendingCoursesKey];
    [defaults setObject:[NSArray arrayWithArray:supervisingCourses] forKey:SupervisingCoursesKey];
    [defaults setObject:[NSArray arrayWithArray:employedSchools] forKey:EmployedSchoolsKey];
    [defaults setObject:[NSArray arrayWithArray:enrolledSchools] forKey:EnrolledSchoolsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isFirstLaunch {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:FirstLaunchKey])
        return false;
    else
        return true;
}

@end