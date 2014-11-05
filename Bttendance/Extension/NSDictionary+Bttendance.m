//
//  NSDictionary+Bttendance.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "NSDictionary+Bttendance.h"

@implementation NSDictionary (Bttendance)

- (NSDictionary *)dictionaryByRemovingNulls {
    
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:self];
    const id null = [NSNull null];
    
    for(NSString *key in self)
        if([self objectForKey:key] == null)
            [replaced removeObjectForKey:key];
    
    return [NSDictionary dictionaryWithDictionary:replaced];
}

@end