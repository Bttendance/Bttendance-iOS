//
//  SimpleAttendanceAlarm.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SimpleAttendanceAlarm.h"

@implementation SimpleAttendanceAlarm

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"type" : @"",
                                         @"scheduledAt" : @"",
                                         @"on" : @YES,
                                         @"author" : @0}];
    return jsonDict;
}

@end
