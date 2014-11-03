//
//  SimpleNotice.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SimpleNotice.h"
#import "Notice.h"
#import "NSData+Bttendance.h"
#import "NSArray+Bttendance.h"

@implementation SimpleNotice

#pragma Override RLMObject Method
- (instancetype)initWithObject:(id)object {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:object];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"seen_students"]] forKey:@"seen_students"];
    return [super initWithObject:dictionary];
}

+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"post" : @0}];
    return jsonDict;
}

#pragma Public Method
- (void)copyDataFromNotice:(id)object {
    Notice *notice = (Notice *)object;
    self.seen_students = notice.seen_students;
}

- (BOOL)seen:(NSInteger)userId {
    for (int i = 0; i < [self seenStudentsCount]; i++)
        if([[self seenStudents][i] integerValue] == userId)
            return YES;
    return NO;
}

#pragma NSArray Converting
- (NSArray *)seenStudents {
    return [NSArray arrayFromData:self.seen_students];
}

- (NSInteger)seenStudentsCount {
    NSArray *students = [self seenStudents];
    if (students == nil)
        return 0;
    
    return students.count;
}

@end
