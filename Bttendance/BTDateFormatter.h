//
//  DataFormatter.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 2. 20..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTDateFormatter : NSObject

+ (NSDate *)dateFromUTC:(NSString *)dateString;

+ (NSString *)stringFromUTC:(NSString *)dateString;

+ (NSTimeInterval)intervalFromUTC:(NSString *)dateString;

@end
