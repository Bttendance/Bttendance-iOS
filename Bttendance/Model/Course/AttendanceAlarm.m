//
//  AttendanceAlarm.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "AttendanceAlarm.h"

@implementation AttendanceAlarm

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"type" : @"",
                                         @"scheduledAt" : @"",
                                         @"on" : @YES}];
    return jsonDict;
}

@end
