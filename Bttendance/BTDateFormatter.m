//
//  DataFormatter.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 2. 20..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTDateFormatter.h"

@implementation BTDateFormatter

+ (NSDate *)dateFromUTC:(NSString *)dateString {
    if (dateString == (NSString *) [NSNull null])
        return nil;

    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

    return [dateformatter dateFromString:dateString];
}

+ (NSString *)stringFromUTC:(NSString *)dateString {
    if (dateString == (NSString *) [NSNull null])
        return nil;

    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateformatter setDateFormat:@"yy/MM/dd HH:mm"];

    return [dateformatter stringFromDate:[self dateFromUTC:dateString]];
}

+ (NSTimeInterval)intervalFromUTC:(NSString *)dateString {
    if (dateString == (NSString *) [NSNull null])
        return -1000;

    return [[self dateFromUTC:dateString] timeIntervalSinceNow];
}

@end
