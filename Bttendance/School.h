//
//  School.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface School : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSString  *name;
@property(strong, nonatomic) NSString  *logo_image;
@property(strong, nonatomic) NSURL  *website;
@property(strong, nonatomic) NSString  *type;
@property(strong, nonatomic) NSArray  *serials;
@property(strong, nonatomic) NSArray  *courses;
@property(strong, nonatomic) NSArray  *professors;
@property(strong, nonatomic) NSArray  *students;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
