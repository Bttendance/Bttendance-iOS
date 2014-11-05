//
//  BTObjectSimple.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTSimpleObject.h"
#import "SimpleUser.h"

@implementation BTSimpleObject

#pragma Override RLMObject Method
+ (NSString *)primaryKey {
    return @"id";
}

+ (NSDictionary *)defaultPropertyValues {
    NSDictionary *jsonDict = @{@"id" : @0};
    return jsonDict;
}

@end
