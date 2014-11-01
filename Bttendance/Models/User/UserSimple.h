//
//  UserSimple.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObjectSimple.h"

@interface UserSimple : BTObjectSimple

@property NSString          *email;
@property NSString          *full_name;

//Added by APIs
@property NSString          *grade;
@property NSString          *student_id;

@end
RLM_ARRAY_TYPE(UserSimple)
