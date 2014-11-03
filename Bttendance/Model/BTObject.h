//
//  BTObject.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTSimpleObject.h"

@interface BTObject : BTSimpleObject

@property NSString *createdAt;
@property NSString *updatedAt;

- (NSDate *) createdDate;
- (NSDate *) updatedDate;

@end
