//
//  ClickerCell.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 5. 2..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ClickerCell.h"

@interface ClickerCell ()

@end

@implementation ClickerCell

+ (ClickerCell *)cellFromNimNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    ClickerCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[ClickerCell class]]) {
            cell = (ClickerCell *) nibItem;
            break;
        }
    }
    return cell;
}

- (void)startTimerAsClicker {
    NSInteger left = MAX(MIN(60, (ceil)(65.0f + [self.post.createdAt timeIntervalSinceNow])), 0);
    self.courseName.text = [NSString stringWithFormat:NSLocalizedString(@"Clicker Ongoing (%ld sec left)", nil), left];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(clickerTimer) userInfo:nil repeats:YES];
}

- (void)clickerTimer {
    NSInteger left = MAX(MIN(60, (ceil)(65.0f + [self.post.createdAt timeIntervalSinceNow])), 0);
    self.courseName.text = [NSString stringWithFormat:NSLocalizedString(@"Clicker Ongoing (%ld sec left)", nil), left];
    if (left == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.courseName.text = NSLocalizedString(@"Clicker", nil);
        return;
    }
}

- (IBAction)click_a:(id)sender {
    [self.delegate chosen:1 andPostId:self.post.id];
}

- (IBAction)click_b:(id)sender {
    [self.delegate chosen:2 andPostId:self.post.id];
}

- (IBAction)click_c:(id)sender {
    [self.delegate chosen:3 andPostId:self.post.id];
}

- (IBAction)click_d:(id)sender {
    [self.delegate chosen:4 andPostId:self.post.id];
}

- (IBAction)click_e:(id)sender {
    [self.delegate chosen:5 andPostId:self.post.id];
}

@end
