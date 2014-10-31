//
//  Attendance.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "Post.h"

@class SimplePost;

@interface SimpleAttendance : NSObject

@property NSInteger         id;
@property NSDate            *createdAt;
@property NSDate            *updatedAt;
@property NSString          *type;
@property NSArray           *checked_students;
@property NSArray           *late_students;
@property NSInteger         post;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSDictionary *)toDictionary:(SimpleAttendance *)attendance;
- (void)copyDataFromAttendance:(id)object;
- (NSInteger)stateInt:(NSInteger)userId;
- (void)toggleStatus:(NSInteger)userId;

@end


@interface Attendance : NSObject

@property NSInteger         id;
@property NSDate            *createdAt;
@property NSDate            *updatedAt;
@property NSString          *type;
@property NSArray           *checked_students;
@property NSArray           *late_students;
@property NSArray           *clusters;
@property SimplePost        *post;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
