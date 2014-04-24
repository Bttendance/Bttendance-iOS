//
//  User.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"

@class SimpleDevice;

@interface SimpleUser : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSString  *username;
@property(strong, nonatomic) NSString  *email;
@property(strong, nonatomic) NSString  *full_name;
@property(strong, nonatomic) NSURL  *profile_image;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface User : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSString  *username;
@property(strong, nonatomic) NSString  *username_lower;
@property(strong, nonatomic) NSString  *email;
@property(strong, nonatomic) NSString  *password;
@property(strong, nonatomic) NSString  *full_name;
@property(strong, nonatomic) NSURL  *profile_image;
@property(strong, nonatomic) SimpleDevice  *device;
@property(strong, nonatomic) NSArray  *supervising_courses;
@property(strong, nonatomic) NSArray  *attending_courses;
@property(strong, nonatomic) NSArray  *employed_schools;
@property(strong, nonatomic) NSArray  *serials;
@property(strong, nonatomic) NSArray  *enrolled_schools;
@property(strong, nonatomic) NSArray  *identifications;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end