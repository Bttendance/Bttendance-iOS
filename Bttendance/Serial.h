//
//  Serial.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "School.h"

@interface Serial : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSString  *key;
@property(strong, nonatomic) School  *school;
@property(strong, nonatomic) NSArray  *owners;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
