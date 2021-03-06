//
//  BTNotification.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 29..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

// For User update
#define UserUpdated @"user_updated"
#define CourseUpdated @"course_updated"

// For refresh
#define FeedRefresh @"feed_refresh"
#define SideRefresh @"side_refresh"

// For open course/post/modalview
#define OpenCourse @"open_course"
#define OpenModalView @"modal_view"
#define OpenNewPost @"open_new_post"

// USERINFO
#define SimpleCourseInfo @"simple_course_info"
#define PostInfo @"post_info"
#define ModalViewController @"modal_view_controller"
#define ModalViewAnim @"modal_view_anim"

// For Socket
#define AttendanceUpdated @"attendance_updated"
#define ClickerUpdated @"clicker_updated"
#define NoticeUpdated @"notice_updated"
#define CuriousUpdated @"curious_updated"
#define PostUpdated @"post_updated"

@interface BTNotification : NSObject

@end
