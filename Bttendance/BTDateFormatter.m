//
//  DataFormatter.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 2. 20..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTDateFormatter.h"

@implementation BTDateFormatter

+ (NSDate *)dateFromString:(NSString *)dateString {
    if (dateString == (NSString *) [NSNull null])
        return nil;
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    return [dateformatter dateFromString:dateString];
}

+ (NSString *)stringFromString:(NSString *)dateString {
    if (dateString == (NSString *) [NSNull null])
        return nil;
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateformatter setDateFormat:@"yy/MM/dd HH:mm"];
    
    return [dateformatter stringFromDate:[self dateFromString:dateString]];
}

+ (NSTimeInterval)intervalFromString:(NSString *)dateString {
    if (dateString == (NSString *) [NSNull null])
        return -1000;
    
    return [[self dateFromString:dateString] timeIntervalSinceNow];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    if (date == nil)
        return nil;
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateformatter setDateFormat:@"yy/MM/dd HH:mm"];
    
    return [dateformatter stringFromDate:date];
}

@end
