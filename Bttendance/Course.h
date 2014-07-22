//
//  Course.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "School.h"

@class SimpleSchool;

@interface SimpleCourse : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSString  *name;
@property(strong, nonatomic) NSString  *professor_name;
@property(assign) NSInteger  school;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface Course : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSString  *name;
@property(strong, nonatomic) NSString  *professor_name;
@property(strong, nonatomic) SimpleSchool  *school;
@property(assign) NSInteger  managers_count;
@property(assign) NSInteger  students_count;
@property(assign) NSInteger  posts_count;
@property(strong, nonatomic) NSString  *code;
@property(assign) BOOL opened;

//Added by APIs
@property(strong, nonatomic) NSString  *attendance_rate;
@property(strong, nonatomic) NSString  *clicker_rate;
@property(strong, nonatomic) NSString  *notice_unseen;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
