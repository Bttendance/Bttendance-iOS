//
//  BTUserDefault.m
//  Bttendance
//
//  Created by H AJE on 2013. 11. 9..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "BTUserDefault.h"

@implementation BTUserDefault

+ (NSString *)getEmail {
    return [self getUser].email;
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

+ (void)clear {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * keys = [defaults dictionaryRepresentation];
    for (id key in keys)
        [defaults removeObjectForKey:key];
    [defaults synchronize];
}

@end