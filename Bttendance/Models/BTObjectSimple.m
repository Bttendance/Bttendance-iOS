//
//  BTObjectSimple.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObjectSimple.h"
#import "NSDictionary+Bttendance.h"
#import "SimpleUser.h"

@implementation BTObjectSimple

#pragma Override RLMObject Method
+ (NSString *)primaryKey {
    return @"id";
}

+ (NSDictionary *)defaultPropertyValues {
    NSDictionary *jsonDict = @{@"id" : @0};
    return jsonDict;
}

@end
