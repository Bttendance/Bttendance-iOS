//
//  SimplePost.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SimplePost.h"

@implementation SimplePost

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"type" : @"",
                                         @"message" : @"",
                                         @"author" : @0,
                                         @"course" : @0}];
    return jsonDict;
}

@end
