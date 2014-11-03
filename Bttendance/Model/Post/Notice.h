//
//  Notice.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "SimplePost.h"

@interface Notice : BTObject

@property NSData            *seen_students;
@property SimplePost        *post;

@end