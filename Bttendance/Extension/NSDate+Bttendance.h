//
//  NSDate+Bttendance.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 2. 20..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATE_FORMAT_SERVER @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
#define DATE_FORMAT_POST @"yy/MM/dd HH:mm"
#define DATE_FORMAT_WHOLE @"yyyy/MM/dd HH:mm"
#define DATE_FORMAT_DATE @"yyyy/MM/dd"
#define DATE_FORMAT_TIME @"HH:mm"

@interface NSDate (Bttendance)

+ (NSDate *)dateFromServerString:(NSString *)string;

+ (NSString *)stringWithDate:(NSDate *) date withFormat:(NSString *)format;

@end
