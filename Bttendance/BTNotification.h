//
//  BTNotification.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 29..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserUpdated @"user_updated"

#define FeedRefresh @"feed_refresh"
#define SideRefresh @"side_refresh"

// For Socket
#define CourseUpdated @"course_updated"
#define AttendanceUpdated @"attendance_updated"
#define ClickerUpdated @"clicker_updated"
#define NoticeUpdated @"notice_updated"

@interface BTNotification : NSObject

@end
