//
//  PushNoti.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface PushNoti : RLMObject

typedef NS_ENUM(NSInteger, PushNotiType) {
    PushNotiType_Attendance_Will_Start,
    PushNotiType_Attendance_Started,
    PushNotiType_Attendance_On_Going,
    PushNotiType_Attendance_Checked,
    PushNotiType_Clicker_Started,
    PushNotiType_Clicker_On_Going,
    PushNotiType_Notice_Created,
    PushNotiType_Notice_Updated,
    PushNotiType_Curious_Commented,
    PushNotiType_Added_As_Manager,
    PushNotiType_Course_Created,
    PushNotiType_Etc
};

@property NSString          *type;
@property NSString          *courseID;
@property NSString          *title;
@property NSString          *message;

- (PushNotiType)getPushNotiType;

@end
