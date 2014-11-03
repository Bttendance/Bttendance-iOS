//
//  Curious.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "SimplePost.h"

@interface Curious : BTObject

@property NSData            *liked_users;
@property NSData            *followers;
@property SimplePost        *post;

@end
