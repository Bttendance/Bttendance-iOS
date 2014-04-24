//
//  Clicker.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@class Post;

@interface Clicker : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(assign) NSInteger  *choice_count;
@property(strong, nonatomic) NSArray  *a_students;
@property(strong, nonatomic) NSArray  *b_students;
@property(strong, nonatomic) NSArray  *c_students;
@property(strong, nonatomic) NSArray  *d_students;
@property(strong, nonatomic) NSArray  *e_students;
@property(strong, nonatomic) Post  *post;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
