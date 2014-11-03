//
//  SimpleClicker.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "XYPieChart.h"

@interface SimpleClicker : BTObject <XYPieChartDataSource>

@property NSData            *a_students;
@property NSData            *b_students;
@property NSData            *c_students;
@property NSData            *d_students;
@property NSData            *e_students;
@property NSInteger         choice_count;
@property NSInteger         progress_time;
@property BOOL              show_info_on_select;
@property NSString          *detail_privacy;
@property NSInteger         post;

- (void)copyDataFromClicker:(id)object;

- (NSString *)detailText;
- (NSString *)participation;
- (NSString *)percent:(NSInteger)choice;
- (NSString *)choice:(NSInteger)userId;
- (NSInteger)choiceInt:(NSInteger)userId;

- (NSArray *)aStudents;
- (NSArray *)bStudents;
- (NSArray *)cStudents;
- (NSArray *)dStudents;
- (NSArray *)eStudents;

- (NSArray *)totalStudents;

- (NSInteger)aStudentsCount;
- (NSInteger)bStudentsCount;
- (NSInteger)cStudentsCount;
- (NSInteger)dStudentsCount;
- (NSInteger)eStudentsCount;

- (NSInteger)totalStudentsCount;

@end
