//
//  Notice.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@class SimplePost;

@interface SimpleNotice : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSArray  *seen_students;
@property(assign) NSInteger  post;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)copyDataFromNotice:(id)object;
- (BOOL)seen:(NSInteger)userId;

@end


@interface Notice : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSArray  *seen_students;
@property(strong, nonatomic) SimplePost  *post;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end