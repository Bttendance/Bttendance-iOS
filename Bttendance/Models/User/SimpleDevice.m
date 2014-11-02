//
//  SimpleDevice.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SimpleDevice.h"

@implementation SimpleDevice

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"type" : @"",
                                         @"uuid" : @"",
                                         @"notification_key" : @""}];
    return jsonDict;
}

@end
