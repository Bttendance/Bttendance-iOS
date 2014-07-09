//
//  GuideViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 7..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ViewController.h"
#import <SwipeView.h>

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

@end
