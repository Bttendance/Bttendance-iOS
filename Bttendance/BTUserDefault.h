//
//  BTUserDefault.h
//  Bttendance
//
//  Created by H AJE on 2013. 11. 9..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define UsernameKey @"btd_username"
#define PasswordKey @"btd_password"
#define UUIDKey @"BT_UUIDKey"
#define UseridKey @"btd_userid"
#define EmailKey @"btd_email"
#define FullNameKey @"btd_fullname"
#define AttendingCoursesKey @"btd_attending_courses"
#define SupervisingCoursesKey @"btd_supervising_courses"
#define EmployedSchoolsKey @"btd_employed_schools"
#define EnrolledSchoolsKey @"btd_enrolled_schools"

@interface BTUserDefault : NSObject {
   
}

+ (NSString *) getUUIDstr;
+ (CBMutableService *) getUserService;
+ (NSString *)representativeString:(CBUUID *) _CBUUID ;
+ (BOOL)isFirstLaunch;

+ (NSDictionary *) getUserInfo;
+ (void)setUserInfo:(id) responseObject;


@end
