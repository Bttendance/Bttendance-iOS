//
//  Post.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Post.h"
#import "NSDate+Bttendance.h"

@implementation Post

- (NSTimeInterval) createdDateTimeInterval {
    return [[NSDate dateFromServerString:self.createdAt] timeIntervalSinceNow];
}

- (NSString *) createdDatePostFormat {
    return [NSDate stringWithDate:[NSDate dateFromServerString:self.createdAt] withFormat:DATE_FORMAT_POST];
}

- (NSString *) createdDateWholeFormat {
    return [NSDate stringWithDate:[NSDate dateFromServerString:self.createdAt] withFormat:DATE_FORMAT_WHOLE];
}

- (NSString *) createdDateDateFormat {
    return [NSDate stringWithDate:[NSDate dateFromServerString:self.createdAt] withFormat:DATE_FORMAT_DATE];
}

- (NSString *) createdDateTimeFormat {
    return [NSDate stringWithDate:[NSDate dateFromServerString:self.createdAt] withFormat:DATE_FORMAT_TIME];
}

@end
