//
//  SimpleClicker.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SimpleClicker.h"
#import "Clicker.h"
#import "NSData+Bttendance.h"
#import "NSArray+Bttendance.h"
#import "UIColor+Bttendance.h"

@implementation SimpleClicker

- (instancetype)initWithObject:(id)object {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:object];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"a_students"]] forKey:@"a_students"];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"b_students"]] forKey:@"b_students"];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"c_students"]] forKey:@"c_students"];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"d_students"]] forKey:@"d_students"];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"e_students"]] forKey:@"e_students"];
    return [super initWithObject:dictionary];
}

- (void)copyDataFromClicker:(id)object {
    Clicker *clicker = (Clicker *)object;
    self.choice_count = clicker.choice_count;
    self.a_students = clicker.a_students;
    self.b_students = clicker.b_students;
    self.c_students = clicker.c_students;
    self.d_students = clicker.d_students;
    self.e_students = clicker.e_students;
}

- (NSString *)detailText {
    float participatedStudents = [self totalStudentsCount];
    NSInteger a=0, b=0, c=0, d=0, e=0;
    if (participatedStudents != 0) {
        b = floor((float)[self bStudentsCount] * 100.0 / participatedStudents + 0.5);
        c = floor((float)[self cStudentsCount] * 100.0 / participatedStudents + 0.5);
        d = floor((float)[self dStudentsCount] * 100.0 / participatedStudents + 0.5);
        e = floor((float)[self eStudentsCount] * 100.0 / participatedStudents + 0.5);
        a = 100 - b - c - d - e;
    }

    NSString *clickerMessage = [NSString stringWithFormat:@"A : %d%%", (int)a];
    clickerMessage = [clickerMessage stringByAppendingString:[NSString stringWithFormat:@"  B : %d%%", (int)b]];
    if (self.choice_count > 2)
        clickerMessage = [clickerMessage stringByAppendingString:[NSString stringWithFormat:@"  C : %d%%", (int)c]];
    if (self.choice_count > 3)
        clickerMessage = [clickerMessage stringByAppendingString:[NSString stringWithFormat:@"  D : %d%%", (int)d]];
    if (self.choice_count > 4)
        clickerMessage = [clickerMessage stringByAppendingString:[NSString stringWithFormat:@"  E : %d%%", (int)e]];

    return clickerMessage;
    return nil;
}

- (NSString *)participation {
    return [NSString stringWithFormat:@"%ld", (long) [self totalStudentsCount]];
}

- (NSString *)choice:(NSInteger)userId {
    
    switch ([self choiceInt:userId]) {
        case 1:
            return @"A";
        case 2:
            return @"B";
        case 3:
            return @"C";
        case 4:
            return @"D";
        case 5:
            return @"E";
        default:
            return nil;
    }
}
- (NSInteger)choiceInt:(NSInteger)userId {
    
    for (int i = 0; i < [self aStudentsCount]; i++)
        if([[self aStudents][i] integerValue] == userId)
            return 1;
    
    for (int i = 0; i < [self bStudentsCount]; i++)
        if([[self bStudents][i] integerValue] == userId)
            return 2;
    
    for (int i = 0; i < [self cStudentsCount]; i++)
        if([[self cStudents][i] integerValue] == userId)
            return 3;
    
    for (int i = 0; i < [self dStudentsCount]; i++)
        if([[self dStudents][i] integerValue] == userId)
            return 4;
    
    for (int i = 0; i < [self eStudentsCount]; i++)
        if([[self eStudents][i] integerValue] == userId)
            return 5;
    
    return 6;
}

- (NSString *)percent:(NSInteger)choice {
    float participatedStudents = [self totalStudentsCount];
    NSInteger a=0, b=0, c=0, d=0, e=0;
    if (participatedStudents != 0) {
        b = floor((float)[self bStudentsCount] * 100.0 / participatedStudents + 0.5);
        c = floor((float)[self cStudentsCount] * 100.0 / participatedStudents + 0.5);
        d = floor((float)[self dStudentsCount] * 100.0 / participatedStudents + 0.5);
        e = floor((float)[self eStudentsCount] * 100.0 / participatedStudents + 0.5);
        a = 100 - b - c - d - e;
    }

    switch (choice) {
        case 1:
            return [NSString stringWithFormat:@"%ld", (long)a];
        case 2:
            return [NSString stringWithFormat:@"%ld", (long)b];
        case 3:
            return [NSString stringWithFormat:@"%ld", (long)c];
        case 4:
            return [NSString stringWithFormat:@"%ld", (long)d];
        case 5:
        default:
            return [NSString stringWithFormat:@"%ld", (long)e];
    }
    return nil;
}

#pragma XYPieChartDataSource
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return self.choice_count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    
    if ([self totalStudentsCount] == 0)
        return 1;

    switch (index) {
        case 0:
            return [self aStudentsCount];
        case 1:
            return [self bStudentsCount];
        case 2:
            if (self.choice_count < 3)
                return 0;
            else
                return [self cStudentsCount];
        case 3:
            if (self.choice_count < 4)
                return 0;
            else
                return [self dStudentsCount];
        case 4:
            if (self.choice_count < 5)
                return 0;
            else
                return [self eStudentsCount];
        default:
            return 0;
    }
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    
    switch (index) {
        case 0:
            return [UIColor clicker_a:1];
        case 1:
            return [UIColor clicker_b:1];
        case 2:
            return [UIColor clicker_c:1];
        case 3:
            return [UIColor clicker_d:1];
        case 4:
            return [UIColor clicker_e:1];
        default:
            return [UIColor clicker_a:1];
    }
}

#pragma NSArray Converting
- (NSArray *)aStudents {
    return [NSArray arrayFromData:self.a_students];
}

- (NSArray *)bStudents {
    return [NSArray arrayFromData:self.b_students];
}

- (NSArray *)cStudents {
    return [NSArray arrayFromData:self.c_students];
}

- (NSArray *)dStudents {
    return [NSArray arrayFromData:self.d_students];
}

- (NSArray *)eStudents {
    return [NSArray arrayFromData:self.e_students];
}

- (NSInteger)aStudentsCount {
    NSArray *students = [self aStudents];
    if (students == nil)
        return 0;
    
    return students.count;
}

- (NSInteger)bStudentsCount {
    NSArray *students = [self bStudents];
    if (students == nil)
        return 0;
    
    return students.count;
}

- (NSInteger)cStudentsCount {
    NSArray *students = [self cStudents];
    if (students == nil)
        return 0;
    
    return students.count;
}

- (NSInteger)dStudentsCount {
    NSArray *students = [self dStudents];
    if (students == nil)
        return 0;
    
    return students.count;
}

- (NSInteger)eStudentsCount {
    NSArray *students = [self eStudents];
    if (students == nil)
        return 0;
    
    return students.count;
}

#pragma Private Methods
- (NSInteger)totalStudentsCount {
    return [self aStudentsCount] + [self bStudentsCount] + [self cStudentsCount] + [self dStudentsCount] + [self eStudentsCount];
}


@end
