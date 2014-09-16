//
//  Post.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Post.h"
#import "NSDate+Bttendance.h"
#import "NSDictionary+Bttendance.h"

@implementation SimplePost

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.type = [dictionary objectForKey:@"type"];
        self.message = [dictionary objectForKey:@"message"];
        self.author = [[dictionary objectForKey:@"author"] integerValue];
        self.course = [[dictionary objectForKey:@"course"] integerValue];
    }
    return self;
}

@end

@implementation Post

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [NSDate dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [NSDate dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.type = [dictionary objectForKey:@"type"];
        self.message = [dictionary objectForKey:@"message"];
        self.author = [[SimpleUser alloc] initWithDictionary:[dictionary objectForKey:@"author"]];
        self.course = [[SimpleCourse alloc] initWithDictionary:[dictionary objectForKey:@"course"]];
        self.attendance = [[SimpleAttendance alloc] initWithDictionary:[dictionary objectForKey:@"attendance"]];
        self.clicker = [[SimpleClicker alloc] initWithDictionary:[dictionary objectForKey:@"clicker"]];
        self.notice = [[SimpleNotice alloc] initWithDictionary:[dictionary objectForKey:@"notice"]];
    }
    return self;
}

+ (NSDictionary *)toDictionary:(Post *)post {
    
    NSMutableArray *keys = [NSMutableArray array];
    [keys addObject:@"id"];
    [keys addObject:@"createdAt"];
    [keys addObject:@"updatedAt"];
    [keys addObject:@"type"];
    [keys addObject:@"message"];
    [keys addObject:@"author"];
    [keys addObject:@"course"];
    
    if (post.attendance != nil && post.attendance.id != 0)
        [keys addObject:@"attendance"];
    if (post.clicker != nil && post.clicker.id != 0)
        [keys addObject:@"clicker"];
    if (post.notice != nil && post.notice.id != 0)
        [keys addObject:@"notice"];
    
    NSMutableArray *objects = [NSMutableArray array];
    [objects addObject:[NSString stringWithFormat:@"%ld", (long)post.id]];
    [objects addObject:[NSDate serializedStringFromDate:post.createdAt]];
    [objects addObject:[NSDate serializedStringFromDate:post.updatedAt]];
    [objects addObject:post.type];
    [objects addObject:post.message];
    [objects addObject:[SimpleUser toDictionary:post.author]];
    [objects addObject:[SimpleCourse toDictionary:post.course]];
    
    if (post.attendance != nil && post.attendance.id != 0)
        [objects addObject:[SimpleAttendance toDictionary:post.attendance]];
    if (post.clicker != nil && post.clicker.id != 0)
        [objects addObject:[SimpleClicker toDictionary:post.clicker]];
    if (post.notice != nil && post.notice.id != 0)
        [objects addObject:[SimpleNotice toDictionary:post.notice]];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    return dictionary;
}

@end
