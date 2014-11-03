//
//  Question.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 31..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "SimpleUser.h"
#import "SimpleCourse.h"

@interface ClickerQuestion : BTObject

@property SimpleUser        *author;
@property NSString          *message;
@property NSInteger         choice_count;
@property NSInteger         progress_time;
@property BOOL              show_info_on_select;
@property NSString          *detail_privacy;
@property SimpleCourse      *course;

@end
