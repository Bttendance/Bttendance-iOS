//
//  Clicker.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "Post.h"
#import "XYPieChart.h"

@class SimplePost;

@interface SimpleClicker : NSObject <XYPieChartDataSource>

@property NSInteger         id;
@property NSDate            *createdAt;
@property NSDate            *updatedAt;
@property NSInteger         choice_count;
@property NSArray           *a_students;
@property NSArray           *b_students;
@property NSArray           *c_students;
@property NSArray           *d_students;
@property NSArray           *e_students;
@property NSInteger         progress_time;
@property BOOL              show_info_on_select;
@property NSString          *detail_privacy;
@property NSInteger         post;

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

@property NSInteger         id;
@property NSDate            *createdAt;
@property NSDate            *updatedAt;
@property NSInteger         choice_count;
@property NSArray           *a_students;
@property NSArray           *b_students;
@property NSArray           *c_students;
@property NSArray           *d_students;
@property NSArray           *e_students;
@property NSInteger         progress_time;
@property BOOL              show_info_on_select;
@property NSString          *detail_privacy;
@property SimplePost        *post;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
