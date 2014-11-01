//
//  Identification.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"

@class SimpleSchool;
@class SimpleUser;

@interface Identification : BTObject

@property NSString          *identity;
@property SimpleUser        *owner;
@property SimpleSchool      *school;

@end
