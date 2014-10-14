//
//  BTUserDefault.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 9..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "BTUserDefault.h"
#import "BTNotification.h"
#import "Course.h"
#import "Post.h"
#import "Question.h"

@implementation BTUserDefault

+ (NSString *)getEmail {
    return [self getUser].email;
}

+ (NSString *)getFullName {
    return [self getUser].full_name;
}

+ (NSString *)getPassword {
    return [self getUser].password;
}

+ (NSString *)getUUID {
    return [self getUser].device.uuid;
}

+ (User *)getUser {
    NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:UserJSONKey];
    if (jsonString == nil)
        return nil;
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    User *user = [[User alloc] initWithDictionary:json];
    return user;
}

+ (void)setUser:(id)responseObject {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [defaults setObject:jsonString forKey:UserJSONKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserUpdated object:nil];
        });
    });
}

+ (NSArray *)getCourses {
    NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:CoursesJSONKey];
    if (jsonString == nil)
        return nil;
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray *courses = [NSMutableArray array];
    for (NSDictionary *dic in json) {
        Course *course = [[Course alloc] initWithDictionary:dic];
        [courses addObject:course];
    }
    
    return courses;
}

+ (Course *)getCourse:(NSInteger)courseId {
    NSString *courseString = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@_%ld", CourseJSONKey, (long)courseId]];
    if (courseString != nil) {
        NSData *data = [courseString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        Course *course = [[Course alloc] initWithDictionary:json];
        return course;
    } else {
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:CoursesJSONKey];
        if (jsonString == nil)
            return nil;
        
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        for (NSDictionary *dic in json) {
            Course *course = [[Course alloc] initWithDictionary:dic];
            if (course.id == courseId)
                return course;
        }
        
        return nil;
    }
}

+ (void)setCourse:(id)responseObject ofCourse:(NSString *)courseId {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [defaults setObject:jsonString forKey:[NSString stringWithFormat:@"%@_%@", CourseJSONKey, courseId]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:CoursesUpdated object:nil];
        });
    });
}

+ (void)setCourses:(id)responseObject {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if ([jsonString isEqualToString:@"[\n\n]"])
            return;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [defaults setObject:jsonString forKey:CoursesJSONKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:CoursesUpdated object:nil];
        });
    });
}

+ (NSArray *)getPostsOfArray:(NSString *)courseId {
    NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@_%@", PostJSONArrayOfCourseKey, courseId]];
    if (jsonString == nil)
        return nil;
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSMutableArray *posts = [NSMutableArray array];
    for (NSDictionary *dic in responseObject) {
        Post *post = [[Post alloc] initWithDictionary:dic];
        [posts addObject:post];
    }
    return posts;
}

+ (void)setPostsArray:(id)responseObject ofCourse:(NSString *)courseId {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if ([jsonString isEqualToString:@"[\n\n]"])
            return;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [defaults setObject:jsonString forKey:[NSString stringWithFormat:@"%@_%@", PostJSONArrayOfCourseKey, courseId]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
    });
}

+ (void)updateClicker:(Clicker *)clicker ofCourse:(NSString *)courseId {
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@_%@", PostJSONArrayOfCourseKey, courseId]];
        if (jsonString == nil)
            return;
        
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *posts = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            Post *post = [[Post alloc] initWithDictionary:dic];
            if (post.id == clicker.post.id
                && post.clicker != nil
                && (post.clicker.updatedAt == nil
                || [post.clicker.updatedAt compare:clicker.updatedAt] == NSOrderedAscending))
                [post.clicker copyDataFromClicker:clicker];
            [posts addObject:post];
        }
        
        NSMutableArray *postsObjects = [NSMutableArray array];
        for (Post *post in posts) {
            [postsObjects addObject:[Post toDictionary:post]];
        }
        
        NSData *newData = [NSJSONSerialization dataWithJSONObject:postsObjects options:0 error:nil];
        NSString *newJsonString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:newJsonString forKey:[NSString stringWithFormat:@"%@_%@", PostJSONArrayOfCourseKey, courseId]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

+ (void)updateAttendance:(Attendance *)attendance ofCourse:(NSString *)courseId {
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@_%@", PostJSONArrayOfCourseKey, courseId]];
        if (jsonString == nil)
            return;
        
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *posts = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            Post *post = [[Post alloc] initWithDictionary:dic];
            if (post.id == attendance.post.id
                && post.attendance != nil
                && (post.attendance.updatedAt == nil
                    || [post.attendance.updatedAt compare:attendance.updatedAt] == NSOrderedAscending))
                [post.attendance copyDataFromAttendance:attendance];
            [posts addObject:post];
        }
        
        NSMutableArray *postsObjects = [NSMutableArray array];
        for (Post *post in posts) {
            [postsObjects addObject:[Post toDictionary:post]];
        }
        
        NSData *newData = [NSJSONSerialization dataWithJSONObject:postsObjects options:0 error:nil];
        NSString *newJsonString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:newJsonString forKey:[NSString stringWithFormat:@"%@_%@", PostJSONArrayOfCourseKey, courseId]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

+ (void)updateNotice:(Notice *)notice ofCourse:(NSString *)courseId {
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@_%@", PostJSONArrayOfCourseKey, courseId]];
        if (jsonString == nil)
            return;
        
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *posts = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            Post *post = [[Post alloc] initWithDictionary:dic];
            if (post.id == notice.post.id
                && post.notice != nil
                && (post.notice.updatedAt == nil
                    || [post.notice.updatedAt compare:notice.updatedAt] == NSOrderedAscending))
                [post.notice copyDataFromNotice:notice];
            [posts addObject:post];
        }
        
        NSMutableArray *postsObjects = [NSMutableArray array];
        for (Post *post in posts) {
            [postsObjects addObject:[Post toDictionary:post]];
        }
        
        NSData *newData = [NSJSONSerialization dataWithJSONObject:postsObjects options:0 error:nil];
        NSString *newJsonString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:newJsonString forKey:[NSString stringWithFormat:@"%@_%@", PostJSONArrayOfCourseKey, courseId]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

+ (void)updatePost:(Post *)newPost ofCourse:(NSString *)courseId {
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@_%@", PostJSONArrayOfCourseKey, courseId]];
        if (jsonString == nil)
            return;
        
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *posts = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            Post *post = [[Post alloc] initWithDictionary:dic];
            if (post.id == newPost.id)
                [posts addObject:newPost];
            else
                [posts addObject:post];
        }
        
        NSMutableArray *postsObjects = [NSMutableArray array];
        for (Post *post in posts) {
            [postsObjects addObject:[Post toDictionary:post]];
        }
        
        NSData *newData = [NSJSONSerialization dataWithJSONObject:postsObjects options:0 error:nil];
        NSString *newJsonString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:newJsonString forKey:[NSString stringWithFormat:@"%@_%@", PostJSONArrayOfCourseKey, courseId]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

+ (NSArray *)getSchools {
    NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:SchoolsJSONKey];
    if (jsonString == nil)
        return nil;
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray *schools = [NSMutableArray array];
    for (NSDictionary *dic in json) {
        School *school = [[School alloc] initWithDictionary:dic];
        [schools addObject:school];
    }
    
    return schools;
}

+ (void)setSchools:(id)responseObject {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [defaults setObject:jsonString forKey:SchoolsJSONKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)getStudentsOfArray:(NSString *)courseId {
    NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@_%@", StudentJSONArrayOfCourseKey, courseId]];
    if (jsonString == nil)
        return nil;
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSMutableArray *users = [NSMutableArray array];
    for (NSDictionary *dic in responseObject) {
        SimpleUser *user = [[SimpleUser alloc] initWithDictionary:dic];
        [users addObject:user];
    }
    return users;
}

+ (void)setStudentsArray:(id)responseObject ofCourse:(NSString *)courseId {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if ([jsonString isEqualToString:@"[\n\n]"])
            return;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [defaults setObject:jsonString forKey:[NSString stringWithFormat:@"%@_%@", StudentJSONArrayOfCourseKey, courseId]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
    });
}

+ (NSArray *)getQuestions {
    NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:QuestionsJSONKey];
    if (jsonString == nil)
        return nil;
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray *questions = [NSMutableArray array];
    for (NSDictionary *dic in json) {
        Question *question = [[Question alloc] initWithDictionary:dic];
        [questions addObject:question];
    }
    
    return questions;
}

+ (void)setQuestions:(id)responseObject {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [defaults setObject:jsonString forKey:QuestionsJSONKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// First Call is No else is YES
+ (BOOL)getSeenGuide {
    BOOL seenGuide = [[NSUserDefaults standardUserDefaults] boolForKey:SeenGuideKey];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:SeenGuideKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return seenGuide;
}

// 0 for NoCourseView
+ (NSInteger)getLastSeenCourse {
    NSInteger lastCourse = [[NSUserDefaults standardUserDefaults] integerForKey:LastSeenCourseKey];
    
    User *user = [BTUserDefault getUser];
    if (lastCourse == 0 || (![user supervising:lastCourse] && ![user attending:lastCourse])) {
        for (id course in user.supervising_courses) {
            if (((SimpleCourse *) course).opened) {
                lastCourse = ((SimpleCourse *)course).id;
                [self setLastSeenCourse:lastCourse];
                return lastCourse;
            }
        }
        
        for (id course in user.attending_courses) {
            if (((SimpleCourse *) course).opened) {
                lastCourse = ((SimpleCourse *)course).id;
                [self setLastSeenCourse:lastCourse];
                return lastCourse;
            }
        }
        
        [self setLastSeenCourse:0];
        return 0;
    }
    
    return lastCourse;
}

+ (void)setLastSeenCourse:(NSInteger)lastCourse {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:lastCourse forKey:LastSeenCourseKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clear {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * keys = [defaults dictionaryRepresentation];
    for (id key in keys)
        [defaults removeObjectForKey:key];
    [defaults synchronize];
}

@end