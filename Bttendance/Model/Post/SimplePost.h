//
//  SimplePost.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTSimpleObject.h"

@interface SimplePost : BTSimpleObject

@property NSString          *type;
@property NSString          *message;
@property NSInteger         author;
@property NSInteger         course;

@end
