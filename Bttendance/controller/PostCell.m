//
//  PostCell.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "PostCell.h"

@interface PostCell ()
@end

@implementation PostCell

+ (PostCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    PostCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[PostCell class]]) {
            cell = (PostCell *) nibItem;
            break;
        }
    }
    return cell;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted)
        self.selected_bg.hidden = NO;
    else
        self.selected_bg.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected)
        self.selected_bg.hidden = NO;
    else
        self.selected_bg.hidden = YES;
}

- (void)startTimerAsAttendance {
    NSInteger left = MIN(60, (ceil)(65.0f + [self.post.createdAt timeIntervalSinceNow]));
    self.Title.text = [NSString stringWithFormat:NSLocalizedString(@"Attendance Ongoing (%ld sec left)", nil), left];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(attendanceTimer) userInfo:nil repeats:YES];
}

- (void)attendanceTimer {
    NSInteger left = MIN(60, (ceil)(65.0f + [self.post.createdAt timeIntervalSinceNow]));
    self.Title.text = [NSString stringWithFormat:NSLocalizedString(@"Attendance Ongoing (%ld sec left)", nil), left];
    if (left == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.Title.text = NSLocalizedString(@"Attendance", nil);
        return;
    }
}

- (void)startTimerAsClicker {
    NSInteger left = MIN(60, (ceil)(65.0f + [self.post.createdAt timeIntervalSinceNow]));
    self.Title.text = [NSString stringWithFormat:NSLocalizedString(@"Clicker Ongoing (%ld sec left)", nil), left];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(clickerTimer) userInfo:nil repeats:YES];
}

- (void)clickerTimer {
    NSInteger left = MIN(60, (ceil)(65.0f + [self.post.createdAt timeIntervalSinceNow]));
    self.Title.text = [NSString stringWithFormat:NSLocalizedString(@"Clicker Ongoing (%ld sec left)", nil), left];
    if (left == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.Title.text = NSLocalizedString(@"Clicker", nil);
        return;
    }
}

@end