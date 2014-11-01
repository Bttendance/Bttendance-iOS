//
//  BTObject.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "NSDate+Bttendance.h"

@implementation BTObject

- (instancetype)initWithObject:(id)object {
    [object setObject:[NSDate dateFromString:[object objectForKey:@"createdAt"]] forKey:@"createdAt"];
    [object setObject:[NSDate dateFromString:[object objectForKey:@"updatedAt"]] forKey:@"updatedAt"];
    return [self initWithObject:object];
}

@end
