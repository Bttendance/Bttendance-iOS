//
//  SimpleNotice.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"

@interface SimpleNotice : BTObject

@property NSData            *seen_students;
@property NSInteger         post;

- (instancetype)initWithObject:(id)object;
- (void)copyDataFromNotice:(id)object;
- (BOOL)seen:(NSInteger)userId;

@end
