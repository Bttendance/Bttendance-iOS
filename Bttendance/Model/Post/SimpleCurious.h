//
//  SimpleCurious.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"

@interface SimpleCurious : BTObject

@property NSData            *liked_users;
@property NSData            *followers;
@property NSInteger         post;

- (NSArray *)likedUsers;
- (NSArray *)followingUsers;

- (NSInteger)likedUsersCount;
- (NSInteger)followingUsersCount;

@end
