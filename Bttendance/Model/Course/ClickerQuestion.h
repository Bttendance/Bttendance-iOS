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

#define CLICKER_QUESTION_DETAIL_PRIVACY_ALL @"all"
#define CLICKER_QUESTION_DETAIL_PRIVACY_NONE @"none"
#define CLICKER_QUESTION_DETAIL_PRIVACY_PROFESSOR @"professor"

@interface ClickerQuestion : BTObject

@property SimpleUser        *author;
@property NSString          *message;
@property NSInteger         choice_count;
@property NSInteger         progress_time;
@property BOOL              show_info_on_select;
@property NSString          *detail_privacy;
@property SimpleCourse      *course;

@end
