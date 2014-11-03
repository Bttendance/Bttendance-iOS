//
//  Curious.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Curious.h"
#import "NSData+Bttendance.h"

@implementation Curious

#pragma Override RLMObject Method
- (instancetype)initWithObject:(id)object {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:object];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"liked_users"]] forKey:@"liked_users"];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"followers"]] forKey:@"followers"];
    return [super initWithObject:dictionary];
}

@end
