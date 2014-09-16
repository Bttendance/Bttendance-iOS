//
//  Identification.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SimpleSchool;
@class SimpleUser;

@interface SimpleIdentification : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSString  *identity;
@property(assign) NSInteger  school;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface Identification : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSString  *identity;
@property(strong, nonatomic) SimpleUser  *owner;
@property(strong, nonatomic) SimpleSchool  *school;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
