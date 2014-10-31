//
//  School.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface SimpleSchool : RLMObject

@property NSInteger         id;
@property NSString          *name;
@property NSString          *type;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface School : RLMObject

@property NSInteger         id;
@property NSDate            *createdAt;
@property NSDate            *updatedAt;
@property NSString          *name;
@property NSString          *type;
@property NSInteger         courses_count;
@property NSInteger         professors_count;
@property NSInteger         students_count;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
