//
//  Course.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "School.h"

@class SimpleSchool;

@interface SimpleCourse : RLMObject

@property NSInteger         id;
@property NSString          *name;
@property NSString          *professor_name;
@property NSInteger         school;
@property BOOL              opened;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSDictionary *)toDictionary:(SimpleCourse *)course;

@end


@interface Course : RLMObject

@property NSInteger         id;
@property NSDate            *createdAt;
@property NSDate            *updatedAt;
@property NSString          *name;
@property NSString          *professor_name;
@property SimpleSchool      *school;
@property NSArray           *managers;
@property NSInteger         students_count;
@property NSInteger         posts_count;
@property NSString          *code;
@property BOOL              opened;

//Added by APIs
@property NSInteger attendance_rate;
@property NSInteger clicker_rate;
@property NSInteger notice_unseen;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
