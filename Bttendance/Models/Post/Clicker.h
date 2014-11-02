//
//  Clicker.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "SimplePost.h"

@interface Clicker : BTObject

@property NSInteger         choice_count;
@property NSData            *a_students;
@property NSData            *b_students;
@property NSData            *c_students;
@property NSData            *d_students;
@property NSData            *e_students;
@property NSInteger         progress_time;
@property BOOL              show_info_on_select;
@property NSString          *detail_privacy;
@property SimplePost        *post;

@end
