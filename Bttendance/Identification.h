//
//  Identification.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "School.h"

@interface Identification : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSString  *identity;
@property(strong, nonatomic) User  *owner;
@property(strong, nonatomic) School  *school;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
