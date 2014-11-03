//
//  Question.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 31..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ClickerQuestion.h"

@implementation ClickerQuestion

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"message" : @"",
                                         @"choice_count" : @0,
                                         @"progress_time" : @0,
                                         @"show_info_on_select" : @YES,
                                         @"detail_privacy" : @""}];
    return jsonDict;
}

@end
