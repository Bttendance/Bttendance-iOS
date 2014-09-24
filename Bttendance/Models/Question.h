//
//  Question.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 31..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SimpleUser;

@interface SimpleQuestion : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSString  *message;
@property(assign) NSInteger  choice_count;
@property(assign) NSInteger progress_time;
@property(assign) BOOL show_info_on_select;
@property(strong, nonatomic) NSString *detail_privacy;
@property(strong, nonatomic) NSString *a_option_text;
@property(strong, nonatomic) NSString *b_option_text;
@property(strong, nonatomic) NSString *c_option_text;
@property(strong, nonatomic) NSString *d_option_text;
@property(strong, nonatomic) NSString *e_option_text;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface Question : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSString  *message;
@property(assign) NSInteger  choice_count;
@property(assign) NSInteger progress_time;
@property(assign) BOOL show_info_on_select;
@property(strong, nonatomic) NSString *detail_privacy;
@property(strong, nonatomic) NSString *a_option_text;
@property(strong, nonatomic) NSString *b_option_text;
@property(strong, nonatomic) NSString *c_option_text;
@property(strong, nonatomic) NSString *d_option_text;
@property(strong, nonatomic) NSString *e_option_text;
@property(strong, nonatomic) SimpleUser  *owner;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
