//
//  Post.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Post.h"
#import "NSDate+Bttendance.h"
#import "NSData+Bttendance.h"
#import "NSArray+Bttendance.h"

@implementation Post

#pragma Override RLMObject Method
- (instancetype)initWithObject:(id)object {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:object];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"seen_managers"]] forKey:@"seen_managers"];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"seen_students"]] forKey:@"seen_students"];
    return [super initWithObject:dictionary];
}

+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"type" : @"",
                                         @"message" : @"",
                                         @"comments_count" : @0}];
    return jsonDict;
}

#pragma NSArray Converting
- (NSArray *)seenManagers {
    return [NSArray arrayFromData:self.seen_managers];
}

- (NSArray *)seenStudents {
    return [NSArray arrayFromData:self.seen_students];
}

- (NSInteger)seenManagersCount {
    NSArray *students = [self seenManagers];
    if (students == nil)
        return 0;
    
    return students.count;
}

- (NSInteger)seenStudentsCount {
    NSArray *students = [self seenStudents];
    if (students == nil)
        return 0;
    
    return students.count;
}

#pragma Public Method
- (NSTimeInterval) createdDateTimeInterval {
    return [[NSDate dateFromServerString:self.createdAt] timeIntervalSinceNow];
}

- (NSString *) createdDatePostFormat {
    return [NSDate stringWithDate:[NSDate dateFromServerString:self.createdAt] withFormat:DATE_FORMAT_POST];
}

- (NSString *) createdDateWholeFormat {
    return [NSDate stringWithDate:[NSDate dateFromServerString:self.createdAt] withFormat:DATE_FORMAT_WHOLE];
}

- (NSString *) createdDateDateFormat {
    return [NSDate stringWithDate:[NSDate dateFromServerString:self.createdAt] withFormat:DATE_FORMAT_DATE];
}

- (NSString *) createdDateTimeFormat {
    return [NSDate stringWithDate:[NSDate dateFromServerString:self.createdAt] withFormat:DATE_FORMAT_TIME];
}

@end
