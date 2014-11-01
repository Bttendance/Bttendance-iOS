//
//  Identification.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "SimpleUser.h"
#import "SimpleSchool.h"

@interface Identification : BTObject

@property NSString          *identity;
@property SimpleUser        *owner;
@property SimpleSchool      *school;

@end
