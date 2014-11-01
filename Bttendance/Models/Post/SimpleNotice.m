//
//  SimpleNotice.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SimpleNotice.h"
#import "NSData+Bttendance.h"

@implementation SimpleNotice

- (instancetype)initWithObject:(id)object {
    [object setObject:[NSData dataFromArray:[object objectForKey:@"seen_students"]] forKey:@"seen_students"];
    return [super initWithObject:object];
}

- (void)copyDataFromNotice:(id)object {
//    Notice *notice = (Notice *)object;
//    self.seen_students = notice.seen_students;
}

- (BOOL)seen:(NSInteger)userId {
//    for (int i = 0; i < self.seen_students.count; i++)
//        if([self.seen_students[i] integerValue] == userId)
//            return YES;
    
    return NO;
}

@end
