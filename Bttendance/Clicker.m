//
//  Clicker.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Clicker.h"
#import "BTDateFormatter.h"
#import "NSDictionary+Bttendance.h"
#import "BTColor.h"

@implementation SimpleClicker

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.choice_count = [[dictionary objectForKey:@"choice_count"] integerValue];
        self.a_students = [dictionary objectForKey:@"a_students"];
        self.b_students = [dictionary objectForKey:@"b_students"];
        self.c_students = [dictionary objectForKey:@"c_students"];
        self.d_students = [dictionary objectForKey:@"d_students"];
        self.e_students = [dictionary objectForKey:@"e_students"];
        self.post = [[dictionary objectForKey:@"post"] integerValue];
    }
    return self;
}

- (NSString *)detailText {
    float participatedStudents = self.a_students.count + self.b_students.count + self.c_students.count + self.d_students.count + self.e_students.count;
    NSInteger a=0, b=0, c=0, d=0, e=0;
    if (participatedStudents != 0) {
        b = floor((float)self.b_students.count * 100.0 / participatedStudents + 0.5);
        c = floor((float)self.c_students.count * 100.0 / participatedStudents + 0.5);
        d = floor((float)self.d_students.count * 100.0 / participatedStudents + 0.5);
        e = floor((float)self.e_students.count * 100.0 / participatedStudents + 0.5);
        a = 100 - b - c - d - e;
    }
    
    NSString *clickerMessage = [NSString stringWithFormat:@"A : %ld%%", a];
    clickerMessage = [clickerMessage stringByAppendingString:[NSString stringWithFormat:@"  B : %ld%%", b]];
    if (self.choice_count > 2)
        clickerMessage = [clickerMessage stringByAppendingString:[NSString stringWithFormat:@"  C : %ld%%", c]];
    if (self.choice_count > 3)
        clickerMessage = [clickerMessage stringByAppendingString:[NSString stringWithFormat:@"  D : %ld%%", d]];
    if (self.choice_count > 4)
        clickerMessage = [clickerMessage stringByAppendingString:[NSString stringWithFormat:@"  E : %ld%%", e]];
    
    
//    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:clickerMessage];
//    UIFont *boldFont = [UIFont boldSystemFontOfSize:self.label.font.pointSize];
//    NSRange purpleBoldTextRange = [clickerMessage rangeOfString:purpleBoldText];
//    [attrString setAttributes:@{NSFontAttributeName:boldFont}
//                            range:purpleBoldTextRange];
    
    return clickerMessage;
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return self.choice_count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    
    NSInteger participatedStudents = self.a_students.count + self.b_students.count + self.c_students.count + self.d_students.count + self.e_students.count;
    if (participatedStudents == 0)
        return 1;
    
    switch (index) {
        case 0:
            return self.a_students.count;
        case 1:
            return self.b_students.count;
        case 2:
            return self.c_students.count;
        case 3:
            return self.d_students.count;
        case 4:
            return self.e_students.count;
        default:
            return 0;
    }
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    
    switch (index) {
        case 0:
            return [BTColor BT_clicker_a:1];
        case 1:
            return [BTColor BT_clicker_b:1];
        case 2:
            return [BTColor BT_clicker_c:1];
        case 3:
            return [BTColor BT_clicker_d:1];
        case 4:
            return [BTColor BT_clicker_e:1];
        default:
            return [BTColor BT_clicker_a:1];
    }
}

@end


@implementation Clicker

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.choice_count = [[dictionary objectForKey:@"choice_count"] integerValue];
        self.a_students = [dictionary objectForKey:@"a_students"];
        self.b_students = [dictionary objectForKey:@"b_students"];
        self.c_students = [dictionary objectForKey:@"c_students"];
        self.d_students = [dictionary objectForKey:@"d_students"];
        self.e_students = [dictionary objectForKey:@"e_students"];
        self.post = [[SimplePost alloc] initWithDictionary:[dictionary objectForKey:@"post"]];
    }
    return self;
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return self.choice_count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    
    NSInteger participatedStudents = self.a_students.count + self.b_students.count + self.c_students.count + self.d_students.count + self.e_students.count;
    if (participatedStudents == 0)
        return 1;
    
    switch (index) {
        case 0:
            return self.a_students.count;
        case 1:
            return self.b_students.count;
        case 2:
            return self.c_students.count;
        case 3:
            return self.d_students.count;
        case 4:
            return self.e_students.count;
        default:
            return 0;
    }
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    
    switch (index) {
        case 0:
            return [BTColor BT_clicker_a:1];
        case 1:
            return [BTColor BT_clicker_b:1];
        case 2:
            return [BTColor BT_clicker_c:1];
        case 3:
            return [BTColor BT_clicker_d:1];
        case 4:
            return [BTColor BT_clicker_e:1];
        default:
            return [BTColor BT_clicker_a:1];
    }
}

@end
