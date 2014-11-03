//
//  BTBlink.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 5. 5..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTBlink.h"

@implementation BlinkView : NSObject

- (id)initWithView:(UIView *)view andCount:(NSInteger) count {
    self = [super init];
    self.view = view;
    self.count = count;
    return self;
}

@end

@implementation BTBlink

+ (BTBlink *)sharedInstance {
    static BTBlink *blink;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        blink = [[BTBlink alloc]init];
    });
    
    return blink;
}

- (id)init {
    self = [super init];
    dim = YES;
    blinkViews = [[NSMutableArray alloc] init];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(blink:)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    return self;
}

- (void)blink:(NSTimer *)timer {
    [self refreshViews];
    
    for (BlinkView *blinkView in blinkViews) {
        blinkView.count -= 1;
        if (dim) {
            [UIImageView beginAnimations:nil context:NULL];
            [UIImageView setAnimationDuration:1.0];
            blinkView.view.alpha = 0;
            [UIImageView commitAnimations];
        } else {
            [UIImageView beginAnimations:nil context:NULL];
            [UIImageView setAnimationDuration:1.0];
            blinkView.view.alpha = 1;
            [UIImageView commitAnimations];
        }
    }
    
    dim = !dim;
}

- (void)addBlinkView:(BlinkView *)blinkView {
    [self refreshViews];
    [blinkViews addObject:blinkView];
    
    if (blinkViews.count != 0) {
        BlinkView *proto = blinkViews[0];
        blinkView.view.alpha = proto.view.alpha;
        if (dim) {
            [UIImageView beginAnimations:nil context:NULL];
            [UIImageView setAnimationDuration:1.0];
            blinkView.view.alpha = 0;
            [UIImageView commitAnimations];
        } else {
            [UIImageView beginAnimations:nil context:NULL];
            [UIImageView setAnimationDuration:1.0];
            blinkView.view.alpha = 1;
            [UIImageView commitAnimations];
        }
    }
}

- (void)refreshViews {
    for (int i = (int)blinkViews.count - 1; i >= 0; i--) {
        BlinkView *blinkView = blinkViews[i];
        if (blinkView == nil || blinkView.view == nil || blinkView.count < 0) {
            blinkView.view.alpha = 1;
            [blinkViews removeObject:blinkView];
        }
    }
}

- (void)removeView:(UIView *)view {
    [self refreshViews];
    for (int i = (int)blinkViews.count - 1; i >= 0; i--) {
        BlinkView *blinkView = blinkViews[i];
        if (blinkView != nil && blinkView.view == view) {
            blinkView.view.alpha = 1;
            [blinkViews removeObject:blinkView];
        }
    }
}

@end
