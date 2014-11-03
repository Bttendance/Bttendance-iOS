//
//  BTTable.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTTable.h"
#import "BTUserDefault.h"
#import <Realm/Realm.h>

@implementation BTTable

#pragma SharedInstance
+ (BTTable *)sharedInstance {
    static BTTable *table;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [[BTTable alloc]init];
        
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
+ (void)getUserWithData:(void (^)(User *user))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if (table.user == nil) {
            NSString *email = [BTUserDefault getEmail];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"email = %@", email];
            RLMResults *results = [User objectsWithPredicate:pred];
            if (results.count == 1)
                table.user = [results firstObject];
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(table.user);
        });
    });
}

+ (void)updateUser:(User *)user {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        table.user = user;
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:user];
        [realm commitWriteTransaction];
    });
}

#pragma Schools Table (Sort : courses_count)
+ (void)getSchoolsWithData:(void (^)(NSArray *schools))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if (table.schools == nil) {
            table.schools = [NSMutableDictionary dictionary];
            RLMResults *results = [[School allObjects] sortedResultsUsingProperty:@"courses_count"
                                                                        ascending:NO];
            for (School *school in results)
                [table.schools setObject:school forKey:[NSNumber numberWithInteger:school.id]];
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data([table.schools allValues]);
        });
    });
}

+ (void)updateSchools:(NSArray *)schools {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if (table.schools == nil)
            table.schools = [NSMutableDictionary dictionary];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (School *school in schools) {
            [table.schools setObject:school forKey:[NSNumber numberWithInteger:school.id]];
            [realm addOrUpdateObject:school];
        }
        [realm commitWriteTransaction];
    });
}

+ (void)updateSchool:(School *)school {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if (table.schools == nil)
            table.schools = [NSMutableDictionary dictionary];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [table.schools setObject:school forKey:[NSNumber numberWithInteger:school.id]];
        [realm addOrUpdateObject:school];
        [realm commitWriteTransaction];
    });
}

#pragma Courses Table (Sort : id)
+ (void)getCoursesWithData:(void (^)(NSArray *courses))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if (table.courses == nil) {
            table.courses = [NSMutableDictionary dictionary];
            RLMResults *results = [[Course allObjects] sortedResultsUsingProperty:@"id"
                                                                        ascending:NO];
            for (Course *course in results)
                [table.courses setObject:course forKey:[NSNumber numberWithInteger:course.id]];
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data([table.courses allValues]);
        });
    });
}

+ (void)getCourseWithID:(NSInteger)courseID
               withData:(void (^)(Course *course))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if (table.courses == nil) {
            table.courses = [NSMutableDictionary dictionary];
            RLMResults *results = [Course allObjects];
            for (Course *course in results)
                [table.courses setObject:course forKey:[NSNumber numberWithInteger:course.id]];
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data([table.courses objectForKey:[NSNumber numberWithInteger:courseID]]);
        });
    });
}

+ (void)updateCourses:(NSArray *)courses {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if (table.courses == nil)
            table.courses = [NSMutableDictionary dictionary];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (Course *course in courses) {
            [table.courses setObject:course forKey:[NSNumber numberWithInteger:course.id]];
            [realm addOrUpdateObject:course];
        }
        [realm commitWriteTransaction];
    });
}
+ (void)updateCourse:(Course *)course {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if (table.courses == nil)
            table.courses = [NSMutableDictionary dictionary];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [table.courses setObject:course forKey:[NSNumber numberWithInteger:course.id]];
        [realm addOrUpdateObject:course];
        [realm commitWriteTransaction];
    });
}

#pragma Posts Table (Sort : id)
+ (void)getPostsWithCourseID:(NSInteger)courseID
                    WithType:(NSString *)type
                    withData:(void (^)(NSArray *posts))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.postsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil) {
            NSMutableDictionary *posts = [NSMutableDictionary dictionary];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"course.id = %ld", courseID];
            RLMResults *results = [[Post objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                     ascending:NO];
            for (Post *post in results)
                [posts setObject:post forKey:[NSNumber numberWithInteger:post.id]];
            [table.postsOfCourse setObject:posts forKey:[NSNumber numberWithInteger:courseID]];
        }
        
        NSMutableArray *posts = [NSMutableArray array];
        for (Post *post in [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] allValues])
            if ([type isEqualToString:post.type])
                [posts addObject:post];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data(posts);
        });
    });
}

+ (void)updatePosts:(NSArray *)posts ofCourseID:(NSInteger)courseID {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.postsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil)
            [table.postsOfCourse setObject:[NSMutableDictionary dictionary] forKey:[NSNumber numberWithInteger:courseID]];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (Post *post in posts) {
            [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] setObject:post
                                                                                         forKey:[NSNumber numberWithInteger:post.id]];
            [realm addOrUpdateObject:post];
        }
        [realm commitWriteTransaction];
    });
}

+ (void)updatePost:(Post *)post {
    if (post.course == nil || post.course.id == 0)
        return;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.postsOfCourse objectForKey:[NSNumber numberWithInteger:post.course.id]] == nil) {
            NSMutableDictionary *posts = [NSMutableDictionary dictionary];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"course.id = %ld", post.course.id];
            RLMResults *results = [[Post objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                     ascending:NO];
            for (Post *post in results)
                [posts setObject:post forKey:[NSNumber numberWithInteger:post.id]];
            [table.postsOfCourse setObject:posts forKey:[NSNumber numberWithInteger:post.course.id]];
        }
        
        [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:post.id]] setObject:post
                                                                                    forKey:[NSNumber numberWithInteger:post.id]];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:post];
        [realm commitWriteTransaction];
    });
}

+ (void)deletePost:(Post *)post {
    if (post.course == nil || post.course.id == 0)
        return;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.postsOfCourse objectForKey:[NSNumber numberWithInteger:post.course.id]] != nil)
            [[table.postsOfCourse objectForKey:[NSNumber numberWithInteger:post.course.id]] removeObjectForKey:[NSNumber numberWithInteger:post.id]];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:post];
        [realm commitWriteTransaction];
    });
}

+ (void)updateClicker:(Clicker *)clicker {
    if (clicker.post == nil || clicker.post.course == 0)
        return;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.postsOfCourse objectForKey:[NSNumber numberWithInteger:clicker.post.course]] == nil) {
            NSMutableDictionary *posts = [NSMutableDictionary dictionary];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"course.id = %ld", clicker.post.course];
            RLMResults *results = [[Post objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                     ascending:NO];
            for (Post *post in results)
                [posts setObject:post forKey:[NSNumber numberWithInteger:post.id]];
            [table.postsOfCourse setObject:posts forKey:[NSNumber numberWithInteger:clicker.post.course]];
        }
        
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
    if (attendance.post == nil || attendance.post.course == 0)
        return;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.postsOfCourse objectForKey:[NSNumber numberWithInteger:attendance.post.course]] == nil) {
            NSMutableDictionary *posts = [NSMutableDictionary dictionary];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"course.id = %ld", attendance.post.course];
            RLMResults *results = [[Post objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                     ascending:NO];
            for (Post *post in results)
                [posts setObject:post forKey:[NSNumber numberWithInteger:post.id]];
            [table.postsOfCourse setObject:posts forKey:[NSNumber numberWithInteger:attendance.post.course]];
        }
        
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
    if (notice.post == nil || notice.post.course == 0)
        return;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.postsOfCourse objectForKey:[NSNumber numberWithInteger:notice.post.course]] == nil) {
            NSMutableDictionary *posts = [NSMutableDictionary dictionary];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"course.id = %ld", notice.post.course];
            RLMResults *results = [[Post objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                     ascending:NO];
            for (Post *post in results)
                [posts setObject:post forKey:[NSNumber numberWithInteger:post.id]];
            [table.postsOfCourse setObject:posts forKey:[NSNumber numberWithInteger:notice.post.course]];
        }
        
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
    if (curious.post == nil || curious.post.course == 0)
        return;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.postsOfCourse objectForKey:[NSNumber numberWithInteger:curious.post.course]] == nil) {
            NSMutableDictionary *posts = [NSMutableDictionary dictionary];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"course.id = %ld", curious.post.course];
            RLMResults *results = [[Post objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                     ascending:NO];
            for (Post *post in results)
                [posts setObject:post forKey:[NSNumber numberWithInteger:post.id]];
            [table.postsOfCourse setObject:posts forKey:[NSNumber numberWithInteger:curious.post.course]];
        }
        
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
+ (void)getQuestionsWithCourseID:(NSInteger)courseID
                        withData:(void (^)(NSArray *questions))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.questionsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil) {
            NSMutableDictionary *questions = [NSMutableDictionary dictionary];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"course.id = %ld", courseID];
            RLMResults *results = [[ClickerQuestion objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                                ascending:NO];
            for (ClickerQuestion *question in results)
                [questions setObject:question forKey:[NSNumber numberWithInteger:question.id]];
            [table.questionsOfCourse setObject:questions forKey:[NSNumber numberWithInteger:courseID]];
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data([[table.questionsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] allValues]);
        });
    });
}

+ (void)updateQuestions:(NSArray *)questions ofCourseID:(NSInteger)courseID {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.questionsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil)
            [table.questionsOfCourse setObject:[NSMutableDictionary dictionary] forKey:[NSNumber numberWithInteger:courseID]];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (ClickerQuestion *question in questions) {
            [[table.questionsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] setObject:question
                                                                                             forKey:[NSNumber numberWithInteger:question.id]];
            [realm addOrUpdateObject:question];
        }
        [realm commitWriteTransaction];
    });
}

+ (void)updateQuestion:(ClickerQuestion *)question {
    if (question.course == nil || question.course.id == 0)
        return;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.questionsOfCourse objectForKey:[NSNumber numberWithInteger:question.course.id]] == nil) {
            NSMutableDictionary *questions = [NSMutableDictionary dictionary];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"course.id = %ld", question.course.id];
            RLMResults *results = [[ClickerQuestion objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                     ascending:NO];
            for (ClickerQuestion *question in results)
                [questions setObject:question forKey:[NSNumber numberWithInteger:question.id]];
            [table.questionsOfCourse setObject:questions forKey:[NSNumber numberWithInteger:question.course.id]];
        }
        
        [[table.questionsOfCourse objectForKey:[NSNumber numberWithInteger:question.id]] setObject:question
                                                                                            forKey:[NSNumber numberWithInteger:question.id]];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:question];
        [realm commitWriteTransaction];
    });
}

+ (void)deleteQuestion:(ClickerQuestion *)question {
    if (question.course == nil || question.course.id == 0)
        return;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.questionsOfCourse objectForKey:[NSNumber numberWithInteger:question.course.id]] != nil)
            [[table.questionsOfCourse objectForKey:[NSNumber numberWithInteger:question.course.id]] removeObjectForKey:[NSNumber numberWithInteger:question.id]];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:question];
        [realm commitWriteTransaction];
    });
}

#pragma Alarms Table (Sort : id)
+ (void)getAlarmsWithCourseID:(NSInteger)courseID
                     withData:(void (^)(NSArray *alarms))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.alarmsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil) {
            NSMutableDictionary *alarms = [NSMutableDictionary dictionary];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"course.id = %ld", courseID];
            RLMResults *results = [[AttendanceAlarm objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                                ascending:NO];
            for (AttendanceAlarm *alarm in results)
                [alarms setObject:alarm forKey:[NSNumber numberWithInteger:alarm.id]];
            [table.alarmsOfCourse setObject:alarms forKey:[NSNumber numberWithInteger:courseID]];
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data([[table.alarmsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] allValues]);
        });
    });
}

+ (void)updateAlarms:(NSArray *)alarms ofCourseID:(NSInteger)courseID {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.alarmsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil)
            [table.alarmsOfCourse setObject:[NSMutableDictionary dictionary] forKey:[NSNumber numberWithInteger:courseID]];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (AttendanceAlarm *alarm in alarms) {
            [[table.alarmsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] setObject:alarm
                                                                                          forKey:[NSNumber numberWithInteger:alarm.id]];
            [realm addOrUpdateObject:alarm];
        }
        [realm commitWriteTransaction];
    });
}

+ (void)updateAlarm:(AttendanceAlarm *)alarm {
    if (alarm.course == nil || alarm.course.id == 0)
        return;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.alarmsOfCourse objectForKey:[NSNumber numberWithInteger:alarm.course.id]] == nil) {
            NSMutableDictionary *alarms = [NSMutableDictionary dictionary];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"course.id = %ld", alarm.course.id];
            RLMResults *results = [[AttendanceAlarm objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                                ascending:NO];
            for (AttendanceAlarm *alarm in results)
                [alarms setObject:alarm forKey:[NSNumber numberWithInteger:alarm.id]];
            [table.alarmsOfCourse setObject:alarms forKey:[NSNumber numberWithInteger:alarm.course.id]];
        }
        
        [[table.alarmsOfCourse objectForKey:[NSNumber numberWithInteger:alarm.id]] setObject:alarm
                                                                                      forKey:[NSNumber numberWithInteger:alarm.id]];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:alarm];
        [realm commitWriteTransaction];
    });
}

+ (void)deleteAlarm:(AttendanceAlarm *)alarm {
    if (alarm.course == nil || alarm.course.id == 0)
        return;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.alarmsOfCourse objectForKey:[NSNumber numberWithInteger:alarm.course.id]] != nil)
            [[table.alarmsOfCourse objectForKey:[NSNumber numberWithInteger:alarm.course.id]] removeObjectForKey:[NSNumber numberWithInteger:alarm.id]];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:alarm];
        [realm commitWriteTransaction];
    });
}

#pragma Students Table (Sort : full_name)
+ (void)getStudentsWithCourseID:(NSInteger)courseID
                       withData:(void (^)(NSArray *students))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.studentsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil) {
            NSMutableDictionary *students = [NSMutableDictionary dictionary];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"course_id = %ld", courseID];
            RLMResults *results = [[StudentRecord objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                              ascending:NO];
            for (StudentRecord *student in results)
                [students setObject:student forKey:[NSNumber numberWithInteger:student.id]];
            [table.studentsOfCourse setObject:students forKey:[NSNumber numberWithInteger:courseID]];
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data([[table.studentsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] allValues]);
        });
    });
}

+ (void)updateStudents:(NSArray *)students ofCourseID:(NSInteger)courseID {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.studentsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil)
            [table.studentsOfCourse setObject:[NSMutableDictionary dictionary] forKey:[NSNumber numberWithInteger:courseID]];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (StudentRecord *student in students) {
            [[table.studentsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] setObject:student
                                                                                            forKey:[NSNumber numberWithInteger:student.id]];
            [realm addOrUpdateObject:student];
        }
        [realm commitWriteTransaction];
    });
}

#pragma Attendance Records Table (Sort : full_name)
+ (void)getAttendanceRecordsWithCourseID:(NSInteger)courseID
                                withData:(void (^)(NSArray *attendanceRecords))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.attendanceRecordsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil) {
            NSMutableDictionary *attendanceRecords = [NSMutableDictionary dictionary];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"course_id = %ld", courseID];
            RLMResults *results = [[AttendanceRecord objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                              ascending:NO];
            for (AttendanceRecord *attendanceRecord in results)
                [attendanceRecords setObject:attendanceRecord forKey:[NSNumber numberWithInteger:attendanceRecord.id]];
            [table.attendanceRecordsOfCourse setObject:attendanceRecords forKey:[NSNumber numberWithInteger:courseID]];
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data([[table.attendanceRecordsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] allValues]);
        });
    });
}

+ (void)updateAttendanceRecords:(NSArray *)attendanceRecords ofCourseID:(NSInteger)courseID {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.attendanceRecordsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil)
            [table.attendanceRecordsOfCourse setObject:[NSMutableDictionary dictionary] forKey:[NSNumber numberWithInteger:courseID]];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (AttendanceRecord *attendanceRecord in attendanceRecords) {
            [[table.attendanceRecordsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] setObject:attendanceRecord
                                                                                                     forKey:[NSNumber numberWithInteger:attendanceRecord.id]];
            [realm addOrUpdateObject:attendanceRecord];
        }
        [realm commitWriteTransaction];
    });
}

#pragma Clicker Records Table (Sort : full_name)
+ (void)getClickerRecordsWithCourseID:(NSInteger)courseID
                             withData:(void (^)(NSArray *clickerRecords))data {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.clickerRecordsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil) {
            NSMutableDictionary *clickerRecords = [NSMutableDictionary dictionary];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"course_id = %ld", courseID];
            RLMResults *results = [[ClickerRecord objectsWithPredicate:pred] sortedResultsUsingProperty:@"id"
                                                                                                 ascending:NO];
            for (ClickerRecord *clickerRecord in results)
                [clickerRecords setObject:clickerRecord forKey:[NSNumber numberWithInteger:clickerRecord.id]];
            [table.clickerRecordsOfCourse setObject:clickerRecords forKey:[NSNumber numberWithInteger:courseID]];
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            data([[table.clickerRecordsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] allValues]);
        });
    });
}

+ (void)updateClickerRecords:(NSArray *)clickerRecords ofCourseID:(NSInteger)courseID {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BTTable *table = [self sharedInstance];
        
        if ([table.clickerRecordsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] == nil)
            [table.clickerRecordsOfCourse setObject:[NSMutableDictionary dictionary] forKey:[NSNumber numberWithInteger:courseID]];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (ClickerRecord *clickerRecord in clickerRecords) {
            [[table.clickerRecordsOfCourse objectForKey:[NSNumber numberWithInteger:courseID]] setObject:clickerRecord
                                                                                                  forKey:[NSNumber numberWithInteger:clickerRecord.id]];
            [realm addOrUpdateObject:clickerRecord];
        }
        [realm commitWriteTransaction];
    });
}

@end
