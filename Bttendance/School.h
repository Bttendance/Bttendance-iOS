//
//  School.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleSchool : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSString  *name;
@property(strong, nonatomic) NSString  *type;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface School : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSString  *name;
@property(strong, nonatomic) NSString  *type;
@property(assign) NSInteger  courses_count;
@property(assign) NSInteger  professors_count;
@property(assign) NSInteger  students_count;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
