//
//  ClickerRecord.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ClickerRecord.h"

@implementation ClickerRecord

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"email" : @"",
                                         @"full_name" : @"",
                                         @"grade" : @"",
                                         @"student_id" : @"",
                                         @"course_id" : @0}];
    return jsonDict;
}

@end
