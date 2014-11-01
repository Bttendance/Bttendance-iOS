//
//  Course.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "RLMArray.h"
#import "SimpleUser.h"
#import "SimpleSchool.h"

@interface Course : BTObject

@property NSString              *name;
@property NSString              *professor_name;
@property SimpleSchool          *school;
@property RLMArray<SimpleUser>  *managers;
@property NSInteger             students_count;
@property NSInteger             posts_count;
@property NSString              *code;
@property BOOL                  opened;

//Added by APIs
@property NSInteger attendance_rate;
@property NSInteger clicker_rate;
@property NSInteger notice_unseen;

@end
