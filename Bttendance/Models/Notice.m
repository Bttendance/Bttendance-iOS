//
//  Notice.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Notice.h"
#import "NSDate+Bttendance.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleNotice

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [NSDate dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [NSDate dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.seen_students = [dictionary objectForKey:@"seen_students"];
        self.post = [[dictionary objectForKey:@"post"] integerValue];
    }
    return self;
}

+ (NSDictionary *)toDictionary:(SimpleNotice *)notice {
    
    NSMutableArray *keys = [NSMutableArray array];
    [keys addObject:@"id"];
    [keys addObject:@"createdAt"];
    [keys addObject:@"updatedAt"];
    if (notice.seen_students != nil)
        [keys addObject:@"seen_students"];
    [keys addObject:@"post"];
    
    NSMutableArray *objects = [NSMutableArray array];
    [objects addObject:[NSString stringWithFormat:@"%ld", (long)notice.id]];
    [objects addObject:[NSDate serializedStringFromDate:notice.createdAt]];
    [objects addObject:[NSDate serializedStringFromDate:notice.updatedAt]];
    if (notice.seen_students != nil)
        [objects addObject:notice.seen_students];
    [objects addObject:[NSString stringWithFormat:@"%ld", (long)notice.post]];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    return dictionary;
}

- (void)copyDataFromNotice:(id)object {
    Notice *notice = (Notice *)object;
    self.seen_students = notice.seen_students;
}

- (BOOL)seen:(NSInteger)userId {
    for (int i = 0; i < self.seen_students.count; i++)
        if([self.seen_students[i] integerValue] == userId)
            return YES;
    
    return NO;
}

@end


@implementation Notice

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [NSDate dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [NSDate dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.seen_students = [dictionary objectForKey:@"seen_students"];
        self.post = [[SimplePost alloc] initWithDictionary:[dictionary objectForKey:@"post"]];
    }
    return self;
}

@end
