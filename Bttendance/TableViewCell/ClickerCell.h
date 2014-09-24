//
//  ClickerCell.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 5. 2..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@protocol ClickerCellDelegate <NSObject>
@required
- (void)chosen:(NSInteger)choice andPostId:(NSInteger)post_id;
@end

@interface ClickerCell : UITableViewCell

+ (ClickerCell *)cellFromNimNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UIView *background;

@property(weak, nonatomic) IBOutlet UILabel *courseName;
@property(weak, nonatomic) IBOutlet UILabel *message;
@property(weak, nonatomic) IBOutlet UILabel *date;

@property(weak, nonatomic) IBOutlet UIView *bg_a;
@property(weak, nonatomic) IBOutlet UIView *bg_b;
@property(weak, nonatomic) IBOutlet UIView *bg_c;
@property(weak, nonatomic) IBOutlet UIView *bg_d;
@property(weak, nonatomic) IBOutlet UIView *bg_e;

@property(weak, nonatomic) IBOutlet UIButton *ring_a;
@property(weak, nonatomic) IBOutlet UIButton *ring_b;
@property(weak, nonatomic) IBOutlet UIButton *ring_c;
@property(weak, nonatomic) IBOutlet UIButton *ring_d;
@property(weak, nonatomic) IBOutlet UIButton *ring_e;

@property(weak, nonatomic) IBOutlet UIImageView *blink_a;
@property(weak, nonatomic) IBOutlet UIImageView *blink_b;
@property(weak, nonatomic) IBOutlet UIImageView *blink_c;
@property(weak, nonatomic) IBOutlet UIImageView *blink_d;
@property(weak, nonatomic) IBOutlet UIImageView *blink_e;

- (IBAction)click_a:(id)sender;
- (IBAction)click_b:(id)sender;
- (IBAction)click_c:(id)sender;
- (IBAction)click_d:(id)sender;
- (IBAction)click_e:(id)sender;

@property(retain, nonatomic) Post *post;

@property(strong, nonatomic) NSTimer *timer;

@property (nonatomic, weak) id<ClickerCellDelegate> delegate;

- (void)startTimerAsClicker;

@end
