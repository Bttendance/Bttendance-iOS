//
//  Identification.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@class SimpleSchool;
@class SimpleUser;

@interface SimpleIdentification : NSObject

@property NSInteger         id;
@property NSString          *identity;
@property NSInteger         school;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface Identification : NSObject

@property NSInteger         id;
@property NSDate            *createdAt;
@property NSDate            *updatedAt;
@property NSString          *identity;
@property SimpleUser        *owner;
@property SimpleSchool      *school;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
