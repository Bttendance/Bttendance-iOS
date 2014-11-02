//
//  SimpleCourse.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SimpleCourse.h"

@implementation SimpleCourse

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"name" : @"",
                                         @"professor_name" : @"",
                                         @"school" : @0,
                                         @"code" : @"",
                                         @"opened" : @YES}];
    return jsonDict;
}

@end
