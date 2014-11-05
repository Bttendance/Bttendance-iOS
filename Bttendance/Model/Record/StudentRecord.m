//
//  StudentRecord.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "StudentRecord.h"

@implementation StudentRecord

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"email" : @"",
                                         @"full_name" : @"",
                                         @"studentID" : @"",
                                         @"courseID" : @0}];
    return jsonDict;
}

@end
