//
//  BTDatabase.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTDatabase.h"
#import "BTUserDefault.h"
#import <Realm/Realm.h>

#import "User.h"
#import "School.h"
#import "Course.h"
#import "Post.h"
#import "Clicker.h"
#import "Attendance.h"
#import "Notice.h"
#import "Curious.h"
#import "ClickerQuestion.h"
#import "AttendanceAlarm.h"
#import "SimpleUser.h"
#import "AttendanceRecord.h"
#import "ClickerRecord.h"
#import "StudentRecord.h"

#import "BTNotification.h"

@implementation BTDatabase

#pragma SharedInstance
+ (BTDatabase *)sharedInstance {
    static BTDatabase *table;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [[BTDatabase alloc]init];
        
        table.postsOfCourse = [NSMutableDictionary dictionary];
        table.questionsOfCourse = [NSMutableDictionary dictionary];
        table.alarmsOfCourse = [NSMutableDictionary dictionary];
        table.studentsOfCourse = [NSMutableDictionary dictionary];
        table.attendanceRecordsOfCourse = [NSMutableDictionary dictionary];
        table.clickerRecordsOfCourse = [NSMutableDictionary dictionary];
    });
    
    return table;
}

#pragma User Table
+ (void)initializeUser {
    BTDatabase *table = [self sharedInstance];
    
    if (table.user == nil) {
        NSString *email = [BTUserDefault getEmail];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"email = %@", email];
        RLMResults *results = [User objectsWithPredicate:pred];
        if (results.count == 1)
            table.user = [results firstObject];
    }
}

+ (User *)getUser {
    BTDatabase *table = [self sharedInstance];
    [self initializeUser];
    return table.user;
}

+ (void)updateUser:(id)responseObject withData:(void (^)(User *user))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        User *user = [[User alloc] initWithObject:responseObject];
        BTDatabase *table = [self sharedInstance];
        table.user = user;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(table.user);
            [[NSNotificationCenter defaultCenter] postNotificationName:UserUpdated object:nil];
        });
        
        [BTUserDefault setUser:user];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:user];
        [realm commitWriteTransaction];
    });
}

#pragma Schools Table (Sort : courses_count)
+ (void)initializeSchools {
    BTDatabase *table = [self sharedInstance];
    
    if (table.schools == nil) {
        table.schools = [NSMutableDictionary dictionary];
        RLMResults *results = [[School allObjects] sortedResultsUsingProperty:@"courses_count"
                                                                    ascending:NO];
        for (School *school in results)
            [table.schools setObject:school forKey:[NSNumber numberWithInteger:school.id]];
    }
}

+ (void)getSchoolsWithData:(void (^)(NSArray *schools))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initializeSchools];
        
        BTDatabase *table = [self sharedInstance];
        dispatch_async( dispatch_get_main_queue(), ^{
            data([table.schools allValues]);
        });
    });
}

+ (void)updateSchool:(id)responseObject withData:(void (^)(School *school))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initializeSchools];
        
        BTDatabase *table = [self sharedInstance];
        School *school = [[School alloc] initWithObject:responseObject];
        dispatch_async( dispatch_get_main_queue(), ^{
            data(school);
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [table.schools setObject:school forKey:[NSNumber numberWithInteger:school.id]];
        [realm addOrUpdateObject:school];
        [realm commitWriteTransaction];
    });
}

+ (void)updateSchools:(id)responseObject withData:(void (^)(NSArray *schools))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *schools = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            School *school = [[School alloc] initWithObject:dic];
            [schools addObject:school];
        }
        
        [self initializeSchools];
        
        BTDatabase *table = [self sharedInstance];
        for (School *school in schools)
            [table.schools setObject:school forKey:[NSNumber numberWithInteger:school.id]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data([table.schools allValues]);
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (School *school in schools)
            [realm addOrUpdateObject:school];
        [realm commitWriteTransaction];
    });
}

#pragma Courses Table (Sort : id)
+ (void)initializeCourses {
    BTDatabase *table = [self sharedInstance];
    
    if (table.courses == nil) {
        table.courses = [NSMutableDictionary dictionary];
        RLMResults *results = [[Course allObjects] sortedResultsUsingProperty:@"id"
                                                                    ascending:NO];
        for (Course *course in results)
            [table.courses setObject:course forKey:[NSNumber numberWithInteger:course.id]];
    }
}

+ (Course *)getCourseWithID:(NSInteger)courseID {
    BTDatabase *table = [self sharedInstance];
    [self initializeCourses];
    return [table.courses objectForKey:[NSNumber numberWithInteger:courseID]];
}

+ (void)getCoursesWithData:(void (^)(NSArray *courses))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initializeCourses];
        
        BTDatabase *table = [self sharedInstance];
        dispatch_async( dispatch_get_main_queue(), ^{
            data([table.courses allValues]);
        });
    });
}

+ (void)updateCourse:(id)responseObject withData:(void (^)(Course *course))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initializeCourses];
        
        BTDatabase *table = [self sharedInstance];
        Course *course = [[Course alloc] initWithObject:responseObject];
        dispatch_async( dispatch_get_main_queue(), ^{
            data(course);
            [[NSNotificationCenter defaultCenter] postNotificationName:CourseUpdated object:nil];
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [table.courses setObject:course forKey:[NSNumber numberWithInteger:course.id]];
        [realm addOrUpdateObject:course];
        [realm commitWriteTransaction];
    });
}

+ (void)updateCourses:(id)responseObject withData:(void (^)(NSArray *courses))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *courses = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            Course *course = [[Course alloc] initWithObject:dic];
            [courses addObject:course];
        }
        
        [self initializeCourses];
        
        BTDatabase *table = [self sharedInstance];
        for (Course *course in courses)
            [table.courses setObject:course forKey:[NSNumber numberWithInteger:course.id]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data([table.courses allValues]);
            [[NSNotificationCenter defaultCenter] postNotificationName:CourseUpdated object:nil];
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (Course *course in courses)
            [realm addOrUpdateObject:course];
        [realm commitWriteTransaction];
    });
}

#pragma Posts Table (Sort : id)
+ (void)initializePostsWithCourseID:(NSInteger)courseID {
    BTDatabase *table = [self sharedInstance];
    
    if ([table.postsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil) {
        NSMutableDictionary *posts = [NSMutableDictionary dictionary];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"course.id = %ld", courseID];
        RLMResults *results = [[Post objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                 ascending:NO];
        for (Post *post in results)
            [posts setObject:post forKey:[NSNumber numberWithInteger:post.id]];
        [table.postsOfCourse setObject:posts forKey:[NSNumber numberWithInteger:courseID]];
    }
}

+ (void)getPostsWithCourseID:(NSInteger)courseID
                    withType:(NSString *)type
                    withData:(void (^)(NSArray *posts))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initializePostsWithCourseID:courseID];
        
        BTDatabase *table = [self sharedInstance];
        NSMutableArray *typedPosts = [NSMutableArray array];
        for (Post *post in [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] allValues])
            if ([type isEqualToString:post.type])
                [typedPosts addObject:post];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(typedPosts);
        });
    });
}

+ (void)updatePosts:(id)responseObject
         ofCourseID:(NSInteger)courseID
           withType:(NSString *)type
           withData:(void (^)(NSArray *posts))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *posts = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            Post *post = [[Post alloc] initWithObject:dic];
            [posts addObject:post];
        }
        
        [self initializePostsWithCourseID:courseID];
        
        BTDatabase *table = [self sharedInstance];
        for (Post *post in posts)
            [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] setObject:post
                                                                                         forKey:[NSNumber numberWithInteger:post.id]];
        
        NSMutableArray *typedPosts = [NSMutableArray array];
        for (Post *post in [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] allValues])
            if ([type isEqualToString:post.type])
                [typedPosts addObject:post];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(typedPosts);
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (Post *post in posts)
            [realm addOrUpdateObject:post];
        [realm commitWriteTransaction];
    });
}

+ (void)updatePost:(id)responseObject withData:(void (^)(Post *post))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Post *post = [[Post alloc] initWithObject:responseObject];
        if (post.course == nil || post.course.id == 0)
            return;
        
        [self initializePostsWithCourseID:post.course.id];
        
        BTDatabase *table = [self sharedInstance];
        [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:post.id]] setObject:post
                                                                                    forKey:[NSNumber numberWithInteger:post.id]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(post);
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:post];
        [realm commitWriteTransaction];
    });
}

+ (void)deletePost:(id)responseObject withData:(void (^)(Post *post))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Post *post = [[Post alloc] initWithObject:responseObject];
        if (post.course == nil || post.course.id == 0)
            return;
        
        [self initializePostsWithCourseID:post.course.id];
        
        BTDatabase *table = [self sharedInstance];
        [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:post.course.id]] removeObjectForKey:[NSNumber numberWithInteger:post.id]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(post);
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:post];
        [realm commitWriteTransaction];
    });
}

+ (void)updateClicker:(Clicker *)clicker {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (clicker.post == nil || clicker.post.course == 0)
            return;
        
        [self initializePostsWithCourseID:clicker.post.course];
        
        BTDatabase *table = [self sharedInstance];
        Post *post = [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:clicker.post.course]]
                      objectForKey:[NSNumber numberWithInteger:clicker.post.id]];
        
        if ([post.clicker updatedDate] != nil
            && [clicker updatedDate] != nil
            && [[post.clicker updatedDate] compare:[clicker updatedDate]] == NSOrderedAscending) {
            [post.clicker copyDataFromClicker:clicker];
            [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:clicker.post.course]] setObject:post
                                                                                                    forKey:[NSNumber numberWithInteger:clicker.post.id]];
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:post];
            [realm commitWriteTransaction];
        }
    });
}

+ (void)updateAttendance:(Attendance *)attendance {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (attendance.post == nil || attendance.post.course == 0)
            return;
        
        [self initializePostsWithCourseID:attendance.post.course];
        
        BTDatabase *table = [self sharedInstance];
        Post *post = [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:attendance.post.course]]
                      objectForKey:[NSNumber numberWithInteger:attendance.post.id]];
        
        if ([post.attendance updatedDate] != nil && [attendance updatedDate] != nil
            && [[post.attendance updatedDate] compare:[attendance updatedDate]] == NSOrderedDescending) {
            [post.attendance copyDataFromAttendance:attendance];
            [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:attendance.post.course]] setObject:post
                                                                                                       forKey:[NSNumber numberWithInteger:attendance.post.id]];
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:post];
            [realm commitWriteTransaction];
        }
    });
}

+ (void)updateNotice:(Notice *)notice {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (notice.post == nil || notice.post.course == 0)
            return;
        
        [self initializePostsWithCourseID:notice.post.course];
        
        BTDatabase *table = [self sharedInstance];
        Post *post = [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:notice.post.course]]
                      objectForKey:[NSNumber numberWithInteger:notice.post.id]];
        
        if ([post.notice updatedDate] != nil && [notice updatedDate] != nil
            && [[post.notice updatedDate] compare:[notice updatedDate]] == NSOrderedDescending) {
            [post.notice copyDataFromNotice:notice];
            [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:notice.post.course]] setObject:post
                                                                                                   forKey:[NSNumber numberWithInteger:notice.post.id]];
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:post];
            [realm commitWriteTransaction];
        }
    });
}

+ (void)updateCurious:(Curious *)curious {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (curious.post == nil || curious.post.course == 0)
            return;
        
        [self initializePostsWithCourseID:curious.post.course];
        
        BTDatabase *table = [self sharedInstance];
        Post *post = [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:curious.post.course]]
                      objectForKey:[NSNumber numberWithInteger:curious.post.id]];
        
        if ([post.curious updatedDate] != nil && [curious updatedDate] != nil
            && [[post.curious updatedDate] compare:[curious updatedDate]] == NSOrderedDescending) {
            [post.curious copyDataFromCurious:curious];
            [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:curious.post.course]] setObject:post
                                                                                                    forKey:[NSNumber numberWithInteger:curious.post.id]];
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:post];
            [realm commitWriteTransaction];
        }
    });
}

#pragma Questions Table (Sort : id)
+ (void)initializeQuestionsWithCourseID:(NSInteger)courseID {
    BTDatabase *table = [self sharedInstance];
    
    if ([table.questionsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil) {
        NSMutableDictionary *questions = [NSMutableDictionary dictionary];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"course.id = %ld", courseID];
        RLMResults *results = [[ClickerQuestion objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                            ascending:NO];
        for (ClickerQuestion *question in results)
            [questions setObject:question forKey:[NSNumber numberWithInteger:question.id]];
        [table.questionsOfCourse setObject:questions forKey:[NSNumber numberWithInteger:courseID]];
    }
}

+ (void)getQuestionsWithCourseID:(NSInteger)courseID
                        withData:(void (^)(NSArray *questions))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initializeQuestionsWithCourseID:courseID];
        
        BTDatabase *table = [self sharedInstance];
        dispatch_async( dispatch_get_main_queue(), ^{
            data([[table.questionsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] allValues]);
        });
    });
}

+ (void)updateQuestions:(id)responseObject
             ofCourseID:(NSInteger)courseID
               withData:(void (^)(NSArray *questions))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *questions = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            ClickerQuestion *question = [[ClickerQuestion alloc] initWithObject:dic];
            [questions addObject:question];
        }
        
        [self initializeQuestionsWithCourseID:courseID];
        
        BTDatabase *table = [self sharedInstance];
        for (ClickerQuestion *question in questions)
            [[table.questionsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] setObject:question
                                                                                             forKey:[NSNumber numberWithInteger:question.id]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(questions);
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (ClickerQuestion *question in questions)
            [realm addOrUpdateObject:question];
        [realm commitWriteTransaction];
    });
}

+ (void)updateQuestion:(id)responseObject withData:(void (^)(ClickerQuestion *question))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ClickerQuestion *question = [[ClickerQuestion alloc] initWithObject:responseObject];
        if (question.course == nil || question.course.id == 0)
            return;
        
        [self initializeQuestionsWithCourseID:question.course.id];
        
        BTDatabase *table = [self sharedInstance];
        [[table.questionsOfCourse objectForKey:[NSNumber numberWithInteger:question.id]] setObject:question
                                                                                            forKey:[NSNumber numberWithInteger:question.id]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(question);
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:question];
        [realm commitWriteTransaction];
    });
}

+ (void)deleteQuestion:(id)responseObject withData:(void (^)(ClickerQuestion *question))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ClickerQuestion *question = [[ClickerQuestion alloc] initWithObject:responseObject];
        if (question.course == nil || question.course.id == 0)
            return;
        
        [self initializeQuestionsWithCourseID:question.course.id];
        
        BTDatabase *table = [self sharedInstance];
        [[table.questionsOfCourse objectForKey:[NSNumber numberWithInteger:question.course.id]] removeObjectForKey:[NSNumber numberWithInteger:question.id]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(question);
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:question];
        [realm commitWriteTransaction];
    });
}

#pragma Alarms Table (Sort : id)
+ (void)initializeAlarmsWithCourseID:(NSInteger)courseID {
    BTDatabase *table = [self sharedInstance];
    
    if ([table.alarmsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil) {
        NSMutableDictionary *alarms = [NSMutableDictionary dictionary];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"course.id = %ld", courseID];
        RLMResults *results = [[AttendanceAlarm objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                            ascending:NO];
        for (AttendanceAlarm *alarm in results)
            [alarms setObject:alarm forKey:[NSNumber numberWithInteger:alarm.id]];
        [table.alarmsOfCourse setObject:alarms forKey:[NSNumber numberWithInteger:courseID]];
    }
}

+ (void)getAlarmsWithCourseID:(NSInteger)courseID
                     withData:(void (^)(NSArray *alarms))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTDatabase *table = [self sharedInstance];
        [self initializeAlarmsWithCourseID:courseID];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data([[table.alarmsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] allValues]);
        });
    });
}

+ (void)updateAlarms:(id)responseObject
          ofCourseID:(NSInteger)courseID
            withData:(void (^)(NSArray *alarms))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *alarms = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            AttendanceAlarm *alarm = [[AttendanceAlarm alloc] initWithObject:dic];
            [alarms addObject:alarm];
        }
        
        [self initializeAlarmsWithCourseID:courseID];
        
        BTDatabase *table = [self sharedInstance];
        for (AttendanceAlarm *alarm in alarms)
            [[table.alarmsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] setObject:alarm
                                                                                          forKey:[NSNumber numberWithInteger:alarm.id]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(alarms);
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (AttendanceAlarm *alarm in alarms)
            [realm addOrUpdateObject:alarm];
        [realm commitWriteTransaction];
    });
}

+ (void)updateAlarm:(id)responseObject withData:(void (^)(AttendanceAlarm *alarm))data {
    AttendanceAlarm *alarm = [[AttendanceAlarm alloc] initWithObject:responseObject];
    if (alarm.course == nil || alarm.course.id == 0)
        return;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initializeAlarmsWithCourseID:alarm.course.id];
        
        BTDatabase *table = [self sharedInstance];
        [[table.alarmsOfCourse objectForKey:[NSNumber numberWithInteger:alarm.id]] setObject:alarm
                                                                                      forKey:[NSNumber numberWithInteger:alarm.id]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(alarm);
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:alarm];
        [realm commitWriteTransaction];
    });
}

+ (void)deleteAlarm:(id)responseObject withData:(void (^)(AttendanceAlarm *alarm))data {
    AttendanceAlarm *alarm = [[AttendanceAlarm alloc] initWithObject:responseObject];
    if (alarm.course == nil || alarm.course.id == 0)
        return;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initializeAlarmsWithCourseID:alarm.course.id];
        
        BTDatabase *table = [self sharedInstance];
        [[table.alarmsOfCourse objectForKey:[NSNumber numberWithInteger:alarm.course.id]] removeObjectForKey:[NSNumber numberWithInteger:alarm.id]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(alarm);
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:alarm];
        [realm commitWriteTransaction];
    });
}

#pragma Students Table (Sort : full_name)
+ (void)initializeStudentsWithCourseID:(NSInteger)courseID {
    BTDatabase *table = [self sharedInstance];
    
    if ([table.studentsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil) {
        NSMutableDictionary *students = [NSMutableDictionary dictionary];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"courseID = %ld", courseID];
        RLMResults *results = [[StudentRecord objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                          ascending:NO];
        for (StudentRecord *student in results)
            [students setObject:student forKey:[NSNumber numberWithInteger:student.id]];
        [table.studentsOfCourse setObject:students forKey:[NSNumber numberWithInteger:courseID]];
    }
}
+ (void)getStudentsWithCourseID:(NSInteger)courseID
                       withData:(void (^)(NSArray *students))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTDatabase *table = [self sharedInstance];
        [self initializeStudentsWithCourseID:courseID];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data([[table.studentsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] allValues]);
        });
    });
}

+ (void)updateStudents:(id)responseObject
            ofCourseID:(NSInteger)courseID
              withData:(void (^)(NSArray *students))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *students = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            SimpleUser *student = [[SimpleUser alloc] initWithObject:dic];
            [students addObject:student];
        }
        
        [self initializeStudentsWithCourseID:courseID];
        
        BTDatabase *table = [self sharedInstance];
        for (StudentRecord *student in students)
            [[table.studentsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] setObject:student
                                                                                            forKey:[NSNumber numberWithInteger:student.id]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(students);
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (StudentRecord *student in students)
            [realm addOrUpdateObject:student];
        [realm commitWriteTransaction];
    });
}

#pragma Attendance Records Table (Sort : full_name)
+ (void)initializeAttendanceRecordsWithCourseID:(NSInteger)courseID {
    BTDatabase *table = [self sharedInstance];
    
    if ([table.attendanceRecordsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil) {
        NSMutableDictionary *attendanceRecords = [NSMutableDictionary dictionary];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"courseID = %ld", courseID];
        RLMResults *results = [[AttendanceRecord objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                             ascending:NO];
        for (AttendanceRecord *attendanceRecord in results)
            [attendanceRecords setObject:attendanceRecord forKey:[NSNumber numberWithInteger:attendanceRecord.id]];
        [table.attendanceRecordsOfCourse setObject:attendanceRecords forKey:[NSNumber numberWithInteger:courseID]];
    }
}

+ (void)getAttendanceRecordsWithCourseID:(NSInteger)courseID
                                withData:(void (^)(NSArray *attendanceRecords))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTDatabase *table = [self sharedInstance];
        [self initializeAttendanceRecordsWithCourseID:courseID];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data([[table.attendanceRecordsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] allValues]);
        });
    });
}

+ (void)updateAttendanceRecords:(id)responseObject
                     ofCourseID:(NSInteger)courseID
                       withData:(void (^)(NSArray *attendanceRecords))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *attendanceRecords = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            AttendanceRecord *attendanceRecord = [[AttendanceRecord alloc] initWithObject:dic];
            [attendanceRecords addObject:attendanceRecord];
        }
        
        [self initializeAttendanceRecordsWithCourseID:courseID];
        
        BTDatabase *table = [self sharedInstance];
        for (AttendanceRecord *attendanceRecord in attendanceRecords)
            [[table.attendanceRecordsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] setObject:attendanceRecord
                                                                                                     forKey:[NSNumber numberWithInteger:attendanceRecord.id]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(attendanceRecords);
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (AttendanceRecord *attendanceRecord in attendanceRecords)
            [realm addOrUpdateObject:attendanceRecord];
        [realm commitWriteTransaction];
    });
}

#pragma Clicker Records Table (Sort : full_name)
+ (void)initializeClickerRecordsWithCourseID:(NSInteger)courseID {
    BTDatabase *table = [self sharedInstance];
    
    if ([table.clickerRecordsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil) {
        NSMutableDictionary *clickerRecords = [NSMutableDictionary dictionary];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"courseID = %ld", courseID];
        RLMResults *results = [[ClickerRecord objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                          ascending:NO];
        for (ClickerRecord *clickerRecord in results)
            [clickerRecords setObject:clickerRecord forKey:[NSNumber numberWithInteger:clickerRecord.id]];
        [table.clickerRecordsOfCourse setObject:clickerRecords forKey:[NSNumber numberWithInteger:courseID]];
    }
}

+ (void)getClickerRecordsWithCourseID:(NSInteger)courseID
                             withData:(void (^)(NSArray *clickerRecords))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTDatabase *table = [self sharedInstance];
        [self initializeClickerRecordsWithCourseID:courseID];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data([[table.clickerRecordsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] allValues]);
        });
    });
}

+ (void)updateClickerRecords:(id)responseObject
                  ofCourseID:(NSInteger)courseID
                    withData:(void (^)(NSArray *clickerRecords))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *clickerRecords = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            ClickerRecord *clickerRecord = [[ClickerRecord alloc] initWithObject:dic];
            [clickerRecords addObject:clickerRecord];
        }
        
        [self initializeClickerRecordsWithCourseID:courseID];
        
        BTDatabase *table = [self sharedInstance];
        for (ClickerRecord *clickerRecord in clickerRecords)
            [[table.clickerRecordsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] setObject:clickerRecord
                                                                                                  forKey:[NSNumber numberWithInteger:clickerRecord.id]];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(clickerRecords);
        });
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (ClickerRecord *clickerRecord in clickerRecords)
            [realm addOrUpdateObject:clickerRecord];
        [realm commitWriteTransaction];
    });
}

@end
