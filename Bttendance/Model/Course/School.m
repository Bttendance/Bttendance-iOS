//
//  School.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "School.h"

@implementation School

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"name" : @"",
                                         @"type" : @"",
                                         @"courses_count" : @0,
                                         @"professors_count" : @0,
                                         @"students_count" : @0}];
    return jsonDict;
}

@end
