//
//  Notice.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "Post.h"

@class SimplePost;

@interface SimpleNotice : NSObject

@property NSInteger         id;
@property NSDate            *createdAt;
@property NSDate            *updatedAt;
@property NSArray           *seen_students;
@property NSInteger         post;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSDictionary *)toDictionary:(SimpleNotice *)notice;
- (void)copyDataFromNotice:(id)object;
- (BOOL)seen:(NSInteger)userId;

@end


@interface Notice : NSObject

@property NSInteger         id;
@property NSDate            *createdAt;
@property NSDate            *updatedAt;
@property NSArray           *seen_students;
@property SimplePost        *post;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end