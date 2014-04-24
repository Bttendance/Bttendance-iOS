//
//  NSDictionary+Bttendance.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "NSDictionary+Bttendance.h"

@implementation NSDictionary (Bttendance)

- (NSDictionary *)dictionaryByReplacingNullsWithStrings {
    
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:self];
    const id null = [NSNull null];
    const NSString *blank = @"";
    
    for(NSString *key in self) {
        const id object = [self objectForKey:key];
        if(object == null) {
            [replaced setObject:blank forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:replaced];
}

@end
