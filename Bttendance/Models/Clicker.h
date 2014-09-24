//
//  Clicker.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "XYPieChart.h"

@class SimplePost;

@interface SimpleClicker : NSObject <XYPieChartDataSource>

@property(assign) NSInteger id;
@property(assign) NSInteger  choice_count;
@property(strong, nonatomic) NSArray  *a_students;
@property(strong, nonatomic) NSArray  *b_students;
@property(strong, nonatomic) NSArray  *c_students;
@property(strong, nonatomic) NSArray  *d_students;
@property(strong, nonatomic) NSArray  *e_students;
@property(assign) NSInteger progress_time;
@property(assign) BOOL show_info_on_select;
@property(strong, nonatomic) NSString *detail_privacy;
@property(strong, nonatomic) NSString *a_option_text;
@property(strong, nonatomic) NSString *b_option_text;
@property(strong, nonatomic) NSString *c_option_text;
@property(strong, nonatomic) NSString *d_option_text;
@property(strong, nonatomic) NSString *e_option_text;
@property(assign) NSInteger  post;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSDictionary *)toDictionary:(SimpleClicker *)clicker;
- (void)copyDataFromClicker:(id)object;
- (NSString *)detailText;
- (NSString *)participation;
- (NSString *)percent:(NSInteger)choice;
- (NSString *)choice:(NSInteger)userId;
- (NSInteger)choiceInt:(NSInteger)userId;

@end


@interface Clicker : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(assign) NSInteger  choice_count;
@property(strong, nonatomic) NSArray  *a_students;
@property(strong, nonatomic) NSArray  *b_students;
@property(strong, nonatomic) NSArray  *c_students;
@property(strong, nonatomic) NSArray  *d_students;
@property(strong, nonatomic) NSArray  *e_students;
@property(assign) NSInteger progress_time;
@property(assign) BOOL show_info_on_select;
@property(strong, nonatomic) NSString *detail_privacy;
@property(strong, nonatomic) NSString *a_option_text;
@property(strong, nonatomic) NSString *b_option_text;
@property(strong, nonatomic) NSString *c_option_text;
@property(strong, nonatomic) NSString *d_option_text;
@property(strong, nonatomic) NSString *e_option_text;
@property(strong, nonatomic) SimplePost  *post;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
