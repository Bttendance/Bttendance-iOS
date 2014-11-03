//
//  Course.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Course.h"

@implementation Course

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"name" : @"",
                                         @"professor_name" : @"",
                                         @"students_count" : @0,
                                         @"posts_count" : @0,
                                         @"code" : @"",
                                         @"opened" : @YES,
                                         @"questions_count" : @0,
                                         @"information" : @"",
                                         @"beginDate" : @"",
                                         @"endDate" : @"",
                                         @"alarms_count" : @0,
                                         @"attendance_rate" : @0,
                                         @"clicker_rate" : @0,
                                         @"notice_rate" : @0}];
    return jsonDict;
}

@end
