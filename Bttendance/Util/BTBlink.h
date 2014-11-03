//
//  BTBlink.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 5. 5..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlinkView : NSObject

@property(assign, atomic) NSInteger count;
@property(retain, atomic) UIView  *view;

- (id)initWithView:(UIView *)view andCount:(NSInteger) count;

@end

@interface BTBlink : NSObject {
    NSTimer *timer;
    NSMutableArray *blinkViews;
    BOOL dim;
}

+ (BTBlink *)sharedInstance;
- (void)addBlinkView:(BlinkView *)blinkView;
- (void)removeView:(UIView *)view;

@end
