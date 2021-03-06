//
//  GuideViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 7..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SwipeView.h>
#import <QuartzCore/QuartzCore.h>

@interface GuidePageViewController : UIViewController <SwipeViewDataSource, SwipeViewDelegate>

@property (strong, nonatomic) SwipeView *swipeView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *closeBt;
@property (strong, nonatomic) IBOutlet UIButton *nextBt;

- (IBAction)closeGuide:(id)sender;
- (IBAction)nextPage:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *guideFirst;
@property (strong, nonatomic) IBOutlet UIView *guidePoll;
@property (strong, nonatomic) IBOutlet UIView *guideAttd;
@property (strong, nonatomic) IBOutlet UIView *guideNotice;
@property (strong, nonatomic) IBOutlet UIView *guideLast;

@property (strong, nonatomic) UIImageView *guideFirstBG;
@property (strong, nonatomic) UIImageView *guidePollBG;
@property (strong, nonatomic) UIImageView *guideAttdBG;
@property (strong, nonatomic) UIImageView *guideNoticeBG;
@property (strong, nonatomic) UIImageView *guideLastBG;

@property (strong, nonatomic) IBOutlet UIButton *showMorePoll;
@property (strong, nonatomic) IBOutlet UIButton *showMoreAttd;
@property (strong, nonatomic) IBOutlet UIButton *showMoreNotice;

- (IBAction)showTutorialPoll:(id)sender;
- (IBAction)showTutorialAttd:(id)sender;
- (IBAction)showTutorialNotice:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *gdFirstTitle;
@property (strong, nonatomic) IBOutlet UILabel *gdFirstMsg1;
@property (strong, nonatomic) IBOutlet UILabel *gdFirstMsg2;
@property (strong, nonatomic) IBOutlet UILabel *gdFirstMsg3;

@property (strong, nonatomic) IBOutlet UIImageView *gdPollImg;
@property (strong, nonatomic) IBOutlet UIImageView *gdPollImgBar;
@property (strong, nonatomic) IBOutlet UILabel *gdPollTitle;
@property (strong, nonatomic) IBOutlet UILabel *gdPollMsg1;
@property (strong, nonatomic) IBOutlet UILabel *gdPollMsg2;
@property (strong, nonatomic) IBOutlet UILabel *gdPollMsg3;

@property (strong, nonatomic) IBOutlet UIImageView *gdAttdImg;
@property (strong, nonatomic) IBOutlet UIImageView *gdAttdImgBar;
@property (strong, nonatomic) IBOutlet UILabel *gdAttdTitle;
@property (strong, nonatomic) IBOutlet UILabel *gdAttdMsg1;
@property (strong, nonatomic) IBOutlet UILabel *gdAttdMsg2;
@property (strong, nonatomic) IBOutlet UILabel *gdAttdMsg3;

@property (strong, nonatomic) IBOutlet UIImageView *gdNoticeImg;
@property (strong, nonatomic) IBOutlet UIImageView *gdNoticeImgBar;
@property (strong, nonatomic) IBOutlet UILabel *gdNoticeTitle;
@property (strong, nonatomic) IBOutlet UILabel *gdNoticeMsg1;
@property (strong, nonatomic) IBOutlet UILabel *gdNoticeMsg2;
@property (strong, nonatomic) IBOutlet UILabel *gdNoticeMsg3;

@property (strong, nonatomic) IBOutlet UIImageView *gdLastImg;
@property (strong, nonatomic) IBOutlet UILabel *gdLastMsg1;
@property (strong, nonatomic) IBOutlet UILabel *gdLastMsg2;
@property (strong, nonatomic) IBOutlet UILabel *gdLastMsg3;
@property (strong, nonatomic) IBOutlet UIButton *gdLastBt1;
@property (strong, nonatomic) IBOutlet UIButton *gdLastBt2;

@end
