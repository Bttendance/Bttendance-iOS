//
//  BTUserDefault.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 9..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//
#import "User.h"

#define UsernameKey @"btd_username"
#define PasswordKey @"btd_password"
#define UUIDKey @"BT_UUIDKey"
#define UserJSONKey @"btd_user_json"

@interface BTUserDefault : NSObject {

}

+ (NSString *)getUsername;

+ (NSString *)getPassword;

+ (NSString *)getUUID;

+ (User *)getUser;

+ (void)setUser:(id)responseObject;

+ (void)clear;

@end
