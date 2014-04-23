//
//  BTUserDefault.m
//  Bttendance
//
//  Created by H AJE on 2013. 11. 9..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "BTUserDefault.h"
#import "KeychainItemWrapper.h"

@implementation BTUserDefault

+ (NSString *)getUUIDstr {

    NSString *uuid = [[NSUserDefaults standardUserDefaults] stringForKey:UUIDKey];
    if (uuid == nil) {
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"BTDUUID" accessGroup:nil];
        uuid = [keychain objectForKey:(__bridge id) kSecAttrAccount];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:UUIDKey];
    }
    return uuid;
}


+ (CBMutableService *)getUserService {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"BTDUUID" accessGroup:nil];
    NSString *_NSUUID_str = [keychain objectForKey:(__bridge id) kSecAttrAccount];
    if ([_NSUUID_str isEqual:@""]) {
        //make user unique service
        CBUUID *UserUUID = [CBUUID UUIDWithNSUUID:[[NSUUID alloc] init]];
        NSString *_BTD = @"Bttendance";
        NSData *BTD = [_BTD dataUsingEncoding:NSUTF8StringEncoding];
        CBMutableCharacteristic *UserChar = [[CBMutableCharacteristic alloc] initWithType:UserUUID properties:CBCharacteristicPropertyRead value:BTD permissions:CBAttributePermissionsReadable];
        CBMutableService *UserService = [[CBMutableService alloc] initWithType:UserUUID primary:YES];
        UserService.characteristics = @[UserChar];
        _NSUUID_str = [BTUserDefault representativeString:UserService.UUID];
        [keychain setObject:_NSUUID_str forKey:(__bridge id) kSecAttrAccount];
        return UserService;
    } else {
        CBUUID *UserUUID = [CBUUID UUIDWithString:_NSUUID_str];
        CBMutableCharacteristic *UserChar = [[CBMutableCharacteristic alloc] initWithType:UserUUID properties:CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable];
        CBMutableService *UserService = [[CBMutableService alloc] initWithType:UserUUID primary:YES];
        UserService.characteristics = @[UserChar];
        return UserService;
    }
}

+ (NSString *)representativeString:(CBUUID *)_CBUUID {
    NSData *data = [_CBUUID data];

    NSUInteger bytesToConvert = [data length];
    const unsigned char *uuidBytes = [data bytes];
    NSMutableString *outputString = [NSMutableString stringWithCapacity:16];

    for (NSUInteger currentByteIndex = 0; currentByteIndex < bytesToConvert; currentByteIndex++) {
        switch (currentByteIndex) {
            case 3:
            case 5:
            case 7:
            case 9:
                [outputString appendFormat:@"%02x-", uuidBytes[currentByteIndex]];
                break;
            default:
                [outputString appendFormat:@"%02x", uuidBytes[currentByteIndex]];
        }
    }
    return outputString;
}

+ (NSDictionary *)getUserInfo {
    NSString *uuid = [BTUserDefault getUUIDstr];
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:UsernameKey];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:PasswordKey];
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UseridKey];
    NSString *fullname = [[NSUserDefaults standardUserDefaults] stringForKey:FullNameKey];
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:EmailKey];
    NSArray *attendingCourses = [[NSUserDefaults standardUserDefaults] arrayForKey:AttendingCoursesKey];
    NSArray *supervisingCourses = [[NSUserDefaults standardUserDefaults] arrayForKey:SupervisingCoursesKey];
    NSArray *employedSchools = [[NSUserDefaults standardUserDefaults] arrayForKey:EmployedSchoolsKey];
    NSArray *enrolledSchools = [[NSUserDefaults standardUserDefaults] arrayForKey:EnrolledSchoolsKey];

    NSDictionary *user_info = @{UsernameKey : username, PasswordKey : password, UUIDKey : uuid, UseridKey : userid,
            FullNameKey : fullname, EmailKey : email, AttendingCoursesKey : attendingCourses,
            SupervisingCoursesKey : supervisingCourses, EmployedSchoolsKey : employedSchools,
            EnrolledSchoolsKey : enrolledSchools};

    return user_info;
}

+ (void)setUserInfo:(id)responseObject {
    NSString *username = [responseObject objectForKey:@"username"];
    NSString *password = [responseObject objectForKey:@"password"];
    NSString *userid = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"id"]];
    NSString *fullname = [responseObject objectForKey:@"full_name"];
    NSString *email = [responseObject objectForKey:@"email"];
    NSArray *attendingCourses = [responseObject objectForKey:@"attending_courses"];
    NSArray *supervisingCourses = [responseObject objectForKey:@"supervising_courses"];
    NSArray *employedSchools = [responseObject objectForKey:@"employed_schools"];
    NSArray *enrolledSchools = [responseObject objectForKey:@"enrolled_schools"];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithString:username] forKey:UsernameKey];
    [defaults setObject:[NSString stringWithString:password] forKey:PasswordKey];
    [defaults setObject:[NSString stringWithString:userid] forKey:UseridKey];
    [defaults setObject:[NSString stringWithString:fullname] forKey:FullNameKey];
    [defaults setObject:[NSString stringWithString:email] forKey:EmailKey];
    [defaults setObject:[NSArray arrayWithArray:attendingCourses] forKey:AttendingCoursesKey];
    [defaults setObject:[NSArray arrayWithArray:supervisingCourses] forKey:SupervisingCoursesKey];
    [defaults setObject:[NSArray arrayWithArray:employedSchools] forKey:EmployedSchoolsKey];
    [defaults setObject:[NSArray arrayWithArray:enrolledSchools] forKey:EnrolledSchoolsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isFirstLaunch {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:FirstLaunchKey])
        return false;
    else
        return true;
}

@end