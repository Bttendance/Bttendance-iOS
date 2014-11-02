//
//  SimpleClickerQuestion.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SimpleClickerQuestion.h"

@implementation SimpleClickerQuestion

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
