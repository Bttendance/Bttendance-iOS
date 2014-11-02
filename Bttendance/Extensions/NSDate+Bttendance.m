//
//  NSDate+Bttendance.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 2. 20..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "NSDate+Bttendance.h"

@implementation NSDate (Bttendance)

+ (NSDate *)dateFromServerString:(NSString *)string {
    if (string == nil || string == (NSString *) [NSNull null])
        return nil;
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateformatter setDateFormat:DATE_FORMAT_SERVER];
    
    return [dateformatter dateFromString:string];
}

+ (NSString *)stringWithDate:(NSDate *) date withFormat:(NSString *)format {
    if (date == nil)
        return nil;
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateformatter setDateFormat:format];
    
    return [dateformatter stringFromDate:date];
}

@end
