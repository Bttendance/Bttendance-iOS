//
//  Comment.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "SimpleUser.h"
#import "SimplePost.h"

@interface Comment : BTObject

@property SimpleUser        *author;
@property NSString          *message;
@property SimplePost        *post;

@end
