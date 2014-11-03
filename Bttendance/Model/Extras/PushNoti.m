//
//  PushNoti.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "PushNoti.h"

@implementation PushNoti

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSDictionary *jsonDict = @{@"type" : @"",
                               @"course_id" : @"",
                               @"title" : @"",
                               @"message" : @""};
    return jsonDict;
}

#pragma Public Methods
- (PushNotiType)getPushNotiType {
    if ([self.type isEqualToString:@"attendance_will_start"])
        return PushNotiType_Attendance_Will_Start;
    else if ([self.type isEqualToString:@"attendance_started"])
        return PushNotiType_Attendance_Started;
    else if ([self.type isEqualToString:@"attendance_on_going"])
        return PushNotiType_Attendance_On_Going;
    else if ([self.type isEqualToString:@"attendance_checked"])
        return PushNotiType_Attendance_Checked;
    else if ([self.type isEqualToString:@"clicker_started"])
        return PushNotiType_Clicker_Started;
    else if ([self.type isEqualToString:@"clicker_on_going"])
        return PushNotiType_Clicker_On_Going;
    else if ([self.type isEqualToString:@"notice_created"])
        return PushNotiType_Notice_Created;
    else if ([self.type isEqualToString:@"notice_updated"])
        return PushNotiType_Notice_Updated;
    else if ([self.type isEqualToString:@"curious_commented"])
        return PushNotiType_Curious_Commented;
    else if ([self.type isEqualToString:@"added_as_manager"])
        return PushNotiType_Added_As_Manager;
    else if ([self.type isEqualToString:@"course_created"])
        return PushNotiType_Course_Created;
    else
        return PushNotiType_Etc;
}

@end