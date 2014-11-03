//
//  SimpleCurious.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SimpleCurious.h"
#import "NSData+Bttendance.h"
#import "NSArray+Bttendance.h"

@implementation SimpleCurious

#pragma Override RLMObject Method
- (instancetype)initWithObject:(id)object {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:object];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"liked_users"]] forKey:@"liked_users"];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"followers"]] forKey:@"followers"];
    return [super initWithObject:dictionary];
}

+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"post" : @0}];
    return jsonDict;
}

#pragma NSArray Converting
- (NSArray *)likedUsers {
    return [NSArray arrayFromData:self.liked_users];
}

- (NSArray *)followingUsers {
    return [NSArray arrayFromData:self.followers];
}

- (NSInteger)likedUsersCount {
    NSArray *users = [self likedUsers];
    if (users == nil)
        return 0;
    
    return users.count;
}

- (NSInteger)followingUsersCount {
    NSArray *users = [self followingUsers];
    if (users == nil)
        return 0;
    
    return users.count;
}

@end
