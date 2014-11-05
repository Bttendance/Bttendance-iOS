//
//  BTUserDefault.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 9..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "BTUserDefault.h"
#import "BTDatabase.h"

@implementation BTUserDefault

+ (void)migrate {
    NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:UserJSONKey];
    if (jsonString == nil)
        return;
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    User *user = [[User alloc] initWithObject:json];
    if (user == nil || user.email == nil || user.password == nil)
        return;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user.email forKey:EmailKey];
    [defaults setObject:user.password forKey:PasswordKey];
    [defaults setObject:user.device.uuid forKey:UUIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getEmail {
    return [[NSUserDefaults standardUserDefaults] objectForKey:EmailKey];
}

+ (NSString *)getPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:PasswordKey];
}

+ (NSString *)getUUID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:UUIDKey];
}

+ (void)setUser:(User *)user {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user.email forKey:EmailKey];
    [defaults setObject:user.password forKey:PasswordKey];
    [defaults setObject:user.device.uuid forKey:UUIDKey];
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
    
    User *user = [BTDatabase getUser];
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