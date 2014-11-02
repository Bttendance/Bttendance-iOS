//
//  Clicker.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Clicker.h"
#import "NSData+Bttendance.h"

@implementation Clicker

- (instancetype)initWithObject:(id)object {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:object];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"a_students"]] forKey:@"a_students"];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"b_students"]] forKey:@"b_students"];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"c_students"]] forKey:@"c_students"];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"d_students"]] forKey:@"d_students"];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"e_students"]] forKey:@"e_students"];
    return [super initWithObject:dictionary];
}

+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"choice_count" : @0,
                                         @"progress_time" : @0,
                                         @"show_info_on_select" : @YES,
                                         @"detail_privacy" : @""}];
    return jsonDict;
}

@end
