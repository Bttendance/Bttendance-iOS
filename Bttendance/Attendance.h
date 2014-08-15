//
//  Attendance.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@class SimplePost;

@interface SimpleAttendance : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSString  *type;
@property(strong, nonatomic) NSArray  *checked_students;
@property(strong, nonatomic) NSArray  *late_students;
@property(assign) NSInteger  post;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSDictionary *)toDictionary:(SimpleAttendance *)attendance;
- (void)copyDataFromAttendance:(id)object;
- (NSInteger)stateInt:(NSInteger)userId;
- (void)toggleStatus:(NSInteger)userId;

@end


@interface Attendance : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSString  *type;
@property(strong, nonatomic) NSArray  *checked_students;
@property(strong, nonatomic) NSArray  *late_students;
@property(strong, nonatomic) NSArray  *clusters;
@property(strong, nonatomic) SimplePost  *post;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
