//
//  Course.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "School.h"

@interface Course : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSString  *name;
@property(strong, nonatomic) NSString  *number;
@property(strong, nonatomic) NSString  *professor_name;
@property(strong, nonatomic) School  *school;
@property(strong, nonatomic) NSArray  *managers;
@property(strong, nonatomic) NSArray  *students;
@property(strong, nonatomic) NSArray  *posts;
@property(assign) NSInteger  students_count;
@property(strong, nonatomic) NSDate  *attdCheckedAt;
@property(assign) NSInteger  clicker_usage;
@property(assign) NSInteger  notice_usage;

@property(strong, nonatomic) NSString  *grade;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
