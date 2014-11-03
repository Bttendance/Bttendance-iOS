//
//  SimpleUser.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTSimpleObject.h"

@interface SimpleUser : BTSimpleObject

@property NSString          *email;
@property NSString          *full_name;

@end
RLM_ARRAY_TYPE(SimpleUser)
