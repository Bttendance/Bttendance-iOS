//
//  Setting.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Setting.h"

@implementation Setting

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"attendance" : @YES,
                                         @"clicker" : @YES,
                                         @"notice" : @YES,
                                         @"curious" : @YES}];
    return jsonDict;
}

@end
