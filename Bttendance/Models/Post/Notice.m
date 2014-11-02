//
//  Notice.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Notice.h"
#import "NSData+Bttendance.h"

@implementation Notice

- (instancetype)initWithObject:(id)object {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:object];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"seen_students"]] forKey:@"seen_students"];
    return [super initWithObject:dictionary];
}

@end
