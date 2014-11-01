//
//  NSData+Bttendance.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "NSData+Bttendance.h"

@implementation NSData (Bttendance)

+ (NSData *)dataFromArray:(NSMutableArray *)array {
    return [NSKeyedArchiver archivedDataWithRootObject:array];
}

+ (NSArray *)arrayFromData:(NSData *)data {
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
