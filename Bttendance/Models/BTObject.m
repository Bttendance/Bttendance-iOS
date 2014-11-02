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

- (NSDate *) createdDate {
    return [NSDate dateFromServerString:self.createdAt];
}

- (NSDate *) updatedDate {
    return [NSDate dateFromServerString:self.updatedAt];
}

@end
