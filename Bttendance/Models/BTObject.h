//
//  BTObject.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObjectSimple.h"

@interface BTObject : BTObjectSimple

@property NSDate *createdAt;
@property NSDate *updatedAt;

- (instancetype)initWithObject:(id)object;

@end
