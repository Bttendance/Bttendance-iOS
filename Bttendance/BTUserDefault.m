//
//  BTUserDefault.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 9..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "BTUserDefault.h"
#import "Course.h"

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
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [defaults setObject:jsonString forKey:UserJSONKey];
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
    if (lastCourse == 0) {
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
    } else {
        for (id course in [user.supervising_courses arrayByAddingObjectsFromArray:user.attending_courses]) {
            if (!((SimpleCourse *) course).opened && ((SimpleCourse *) course).id == lastCourse) {
                [self setLastSeenCourse:0];
                return 0;
            }
        }
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