//
//  SimpleSchedule.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SimpleSchedule.h"

@implementation SimpleSchedule
+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"course" : @0,
                                         @"weekday" : @"",
                                         @"time" : @"",
                                         @"timezone" : @""}];
    return jsonDict;
}

@end
