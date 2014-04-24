//
//  Notification.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property(strong, nonatomic) NSString  *type; //(attendance_started, attendance_checked, clicker_opened, notice, comments, etc)
@property(strong, nonatomic) NSString  *title;
@property(strong, nonatomic) NSString  *message;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
