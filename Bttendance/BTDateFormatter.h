//
//  DataFormatter.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 2. 20..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTDateFormatter : NSObject

+ (NSDate *)dateFromString:(NSString *)dateString;

+ (NSString *)serializedStringFromDate:(NSDate *)date;

+ (NSString *)stringFromString:(NSString *)dateString;

+ (NSTimeInterval)intervalFromString:(NSString *)dateString;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSString *)detailedStringFromDate:(NSDate *)date;

+ (NSString *)dateStringFromDate:(NSDate *)date;

+ (NSString *)timeStringFromDate:(NSDate *)date;

@end
