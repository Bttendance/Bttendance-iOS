//
//  NSArray+Bttendance.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 2..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "NSArray+Bttendance.h"

@implementation NSArray (Bttendance)

+ (NSArray *)arrayFromData:(NSData *)data {
    if (data == nil)
        return nil;
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
