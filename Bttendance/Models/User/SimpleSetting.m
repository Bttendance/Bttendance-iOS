//
//  SimpleSetting.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SimpleSetting.h"

@implementation SimpleSetting

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
