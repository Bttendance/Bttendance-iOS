//
//  SimpleIdentification.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTSimpleObject.h"

@interface SimpleIdentification : BTSimpleObject

@property NSString          *identity;
@property NSInteger         school;

@end
RLM_ARRAY_TYPE(SimpleIdentification)
