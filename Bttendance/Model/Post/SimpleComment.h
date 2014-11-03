//
//  SimpleComment.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTSimpleObject.h"

@interface SimpleComment : BTSimpleObject

@property NSInteger         author;
@property NSString          *message;

@end
RLM_ARRAY_TYPE(SimpleComment)
