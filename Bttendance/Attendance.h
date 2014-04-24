//
//  Attendance.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@class Post;

@interface Attendance : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSArray  *checked_students;
@property(strong, nonatomic) NSArray  *clusters;
@property(strong, nonatomic) Post  *post;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
