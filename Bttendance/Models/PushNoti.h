//
//  PushNoti.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushNoti : NSObject

//(attendance_started, attendance_checked, clicker_opened, notice, comments, etc)
@property NSString          *type;
@property NSString          *course_id;
@property NSString          *title;
@property NSString          *message;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end