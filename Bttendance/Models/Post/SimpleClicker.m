//
//  SimpleClicker.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SimpleClicker.h"
#import "NSData+Bttendance.h"
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
//    Clicker *clicker = (Clicker *)object;
//    self.choice_count = clicker.choice_count;
//    self.a_students = [NSArray arrayWithArray:clicker.a_students];
//    self.b_students = [NSArray arrayWithArray:clicker.b_students];
//    self.c_students = [NSArray arrayWithArray:clicker.c_students];
//    self.d_students = [NSArray arrayWithArray:clicker.d_students];
//    self.e_students = [NSArray arrayWithArray:clicker.e_students];
}

- (NSString *)detailText {
    //    float participatedStudents = self.a_students.count + self.b_students.count + self.c_students.count + self.d_students.count + self.e_students.count;
    //    NSInteger a=0, b=0, c=0, d=0, e=0;
    //    if (participatedStudents != 0) {
    //        b = floor((float)self.b_students.count * 100.0 / participatedStudents + 0.5);
    //        c = floor((float)self.c_students.count * 100.0 / participatedStudents + 0.5);
    //        d = floor((float)self.d_students.count * 100.0 / participatedStudents + 0.5);
    //        e = floor((float)self.e_students.count * 100.0 / participatedStudents + 0.5);
    //        a = 100 - b - c - d - e;
    //    }
    //
    //    NSString *clickerMessage = [NSString stringWithFormat:@"A : %d%%", (int)a];
    //    clickerMessage = [clickerMessage stringByAppendingString:[NSString stringWithFormat:@"  B : %d%%", (int)b]];
    //    if (self.choice_count > 2)
    //        clickerMessage = [clickerMessage stringByAppendingString:[NSString stringWithFormat:@"  C : %d%%", (int)c]];
    //    if (self.choice_count > 3)
    //        clickerMessage = [clickerMessage stringByAppendingString:[NSString stringWithFormat:@"  D : %d%%", (int)d]];
    //    if (self.choice_count > 4)
    //        clickerMessage = [clickerMessage stringByAppendingString:[NSString stringWithFormat:@"  E : %d%%", (int)e]];
    //
    //    return clickerMessage;
    return nil;
}

- (NSString *)participation {
    //    return [NSString stringWithFormat:@"%ld", (long) (self.a_students.count + self.b_students.count + self.c_students.count + self.d_students.count + self.e_students.count)];
    return nil;
}

- (NSString *)choice:(NSInteger)userId {
    
    //    for (int i = 0; i < self.a_students.count; i++)
    //        if([self.a_students[i] integerValue] == userId)
    //            return @"A";
    //
    //    for (int i = 0; i < self.b_students.count; i++)
    //        if([self.b_students[i] integerValue] == userId)
    //            return @"B";
    //
    //    for (int i = 0; i < self.c_students.count; i++)
    //        if([self.c_students[i] integerValue] == userId)
    //            return @"C";
    //
    //    for (int i = 0; i < self.d_students.count; i++)
    //        if([self.d_students[i] integerValue] == userId)
    //            return @"D";
    //
    //    for (int i = 0; i < self.e_students.count; i++)
    //        if([self.e_students[i] integerValue] == userId)
    //            return @"E";
    
    return nil;
}
- (NSInteger)choiceInt:(NSInteger)userId {
    
    //    for (int i = 0; i < self.a_students.count; i++)
    //        if([self.a_students[i] integerValue] == userId)
    //            return 1;
    //
    //    for (int i = 0; i < self.b_students.count; i++)
    //        if([self.b_students[i] integerValue] == userId)
    //            return 2;
    //
    //    for (int i = 0; i < self.c_students.count; i++)
    //        if([self.c_students[i] integerValue] == userId)
    //            return 3;
    //
    //    for (int i = 0; i < self.d_students.count; i++)
    //        if([self.d_students[i] integerValue] == userId)
    //            return 4;
    //
    //    for (int i = 0; i < self.e_students.count; i++)
    //        if([self.e_students[i] integerValue] == userId)
    //            return 5;
    
    return 6;
}

- (NSString *)percent:(NSInteger)choice {
    //    float participatedStudents = self.a_students.count + self.b_students.count + self.c_students.count + self.d_students.count + self.e_students.count;
    //    NSInteger a=0, b=0, c=0, d=0, e=0;
    //    if (participatedStudents != 0) {
    //        b = floor((float)self.b_students.count * 100.0 / participatedStudents + 0.5);
    //        c = floor((float)self.c_students.count * 100.0 / participatedStudents + 0.5);
    //        d = floor((float)self.d_students.count * 100.0 / participatedStudents + 0.5);
    //        e = floor((float)self.e_students.count * 100.0 / participatedStudents + 0.5);
    //        a = 100 - b - c - d - e;
    //    }
    //
    //    switch (choice) {
    //        case 1:
    //            return [NSString stringWithFormat:@"%ld", (long)a];
    //        case 2:
    //            return [NSString stringWithFormat:@"%ld", (long)b];
    //        case 3:
    //            return [NSString stringWithFormat:@"%ld", (long)c];
    //        case 4:
    //            return [NSString stringWithFormat:@"%ld", (long)d];
    //        case 5:
    //        default:
    //            return [NSString stringWithFormat:@"%ld", (long)e];
    //    }
    return nil;
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return self.choice_count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    
    //    NSInteger participatedStudents = self.a_students.count + self.b_students.count + self.c_students.count + self.d_students.count + self.e_students.count;
    //    if (participatedStudents == 0)
    //        return 1;
    //
    //    switch (index) {
    //        case 0:
    //            return self.a_students.count;
    //        case 1:
    //            return self.b_students.count;
    //        case 2:
    //            if (self.choice_count < 3)
    //                return 0;
    //            else
    //                return self.c_students.count;
    //        case 3:
    //            if (self.choice_count < 4)
    //                return 0;
    //            else
    //                return self.d_students.count;
    //        case 4:
    //            if (self.choice_count < 5)
    //                return 0;
    //            else
    //                return self.e_students.count;
    //        default:
    //            return 0;
    //    }
    return 0;
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

@end
