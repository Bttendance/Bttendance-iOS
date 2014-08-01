//
//  GuideViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 7..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "GuidePageViewController.h"
#import "TutorialViewController.h"
#import "CourseCreateViewController.h"
#import "CourseAttendViewController.h"
#import "BTColor.h"
#import "BTNotification.h"
#import "BTUserDefault.h"
#import "Course.h"

@interface GuidePageViewController ()

@property (assign) BOOL statusBarAnim;
@property (assign) BOOL dissmissItself;

@end

@implementation GuidePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nextBt.titleLabel.text = NSLocalizedString(@"Next", nil);
    
    self.guideFirstBG = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
    self.guidePollBG = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
    self.guideAttdBG = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
    self.guideNoticeBG = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
    self.guideLastBG = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
    
    self.guideFirstBG.image = [UIImage imageNamed:@"welcome_bg.png"];
    self.guidePollBG.image = [UIImage imageNamed:@"poll_bg.png"];
    self.guideAttdBG.image = [UIImage imageNamed:@"attendance_bg.png"];
    self.guideNoticeBG.image = [UIImage imageNamed:@"notice_bg.png"];
    self.guideLastBG.backgroundColor = [BTColor BT_white:1.0];
    
    [[self view] addSubview:self.guideFirstBG];
    [[self view] addSubview:self.guidePollBG];
    [[self view] addSubview:self.guideAttdBG];
    [[self view] addSubview:self.guideNoticeBG];
    [[self view] addSubview:self.guideLastBG];
    
    self.swipeView = [[SwipeView alloc] initWithFrame:[[self view] bounds]];
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    [[self view] addSubview:self.swipeView];
    
    [[self view] bringSubviewToFront:self.pageControl];
    [[self view] bringSubviewToFront:self.closeBt];
    [[self view] bringSubviewToFront:self.nextBt];
    
    self.gdFirstTitle.text = NSLocalizedString(@"환영합니다!", nil);
    self.gdFirstMsg1.text = NSLocalizedString(@"지금부터 BTTENDANCE를", nil);
    self.gdFirstMsg2.text = NSLocalizedString(@"어떻게 사용하실 수 있는지", nil);
    self.gdFirstMsg3.text = NSLocalizedString(@"소개할게요.", nil);
    
    self.gdPollTitle.text = NSLocalizedString(@"설문하기", nil);
    self.gdPollMsg1.text = NSLocalizedString(@"찬반 의견부터 간단한 객관식 답변까지", nil);
    self.gdPollMsg2.text = NSLocalizedString(@"학생들의 반응을 쉽게 파악하세요!", nil);
    self.gdPollMsg3.text = NSLocalizedString(@"", nil);
    
    self.gdAttdTitle.text = NSLocalizedString(@"출석체크", nil);
    self.gdAttdMsg1.text = NSLocalizedString(@"학생수가 많아 일일이 이름 부르기", nil);
    self.gdAttdMsg2.text = NSLocalizedString(@"힘들다면, BTTENDANCE 로 빠르고", nil);
    self.gdAttdMsg3.text = NSLocalizedString(@"정확하게 체크해보시면 어떨까요?", nil);
    
    self.gdNoticeTitle.text = NSLocalizedString(@"공지하기", nil);
    self.gdNoticeMsg1.text = NSLocalizedString(@"학생들에게 BTTENDANCE 로", nil);
    self.gdNoticeMsg2.text = NSLocalizedString(@"중요한 사항을 알리시고,", nil);
    self.gdNoticeMsg3.text = NSLocalizedString(@"누가 읽지 않았는지도 확인하세요!", nil);
    
    self.showMorePoll.titleLabel.text = NSLocalizedString(@"더 알아보기", nil);
    self.showMorePoll.layer.cornerRadius = 3.0;
    self.showMorePoll.layer.borderWidth = 1.2;
    self.showMorePoll.layer.borderColor = [BTColor BT_white:1.0].CGColor;
    [self.showMorePoll setBackgroundImage:[BTColor imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self.showMorePoll setBackgroundImage:[BTColor imageWithCyanColor:0.5] forState:UIControlStateHighlighted];
    self.showMorePoll.layer.masksToBounds = YES;
    
    self.showMoreAttd.titleLabel.text = NSLocalizedString(@"더 알아보기", nil);
    self.showMoreAttd.layer.cornerRadius = 3.0;
    self.showMoreAttd.layer.borderWidth = 1.2;
    self.showMoreAttd.layer.borderColor = [BTColor BT_white:1.0].CGColor;
    [self.showMoreAttd setBackgroundImage:[BTColor imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self.showMoreAttd setBackgroundImage:[BTColor imageWithCyanColor:0.5] forState:UIControlStateHighlighted];
    self.showMoreAttd.layer.masksToBounds = YES;
    
    self.showMoreNotice.titleLabel.text = NSLocalizedString(@"더 알아보기", nil);
    self.showMoreNotice.layer.cornerRadius = 3.0;
    self.showMoreNotice.layer.borderWidth = 1.2;
    self.showMoreNotice.layer.borderColor = [BTColor BT_white:1.0].CGColor;
    [self.showMoreNotice setBackgroundImage:[BTColor imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self.showMoreNotice setBackgroundImage:[BTColor imageWithCyanColor:0.5] forState:UIControlStateHighlighted];
    self.showMoreNotice.layer.masksToBounds = YES;
    
    self.gdLastMsg1.text = NSLocalizedString(@"지금부터", nil);
    self.gdLastMsg2.text = NSLocalizedString(@"BTTENDANCE를", nil);
    self.gdLastMsg3.text = NSLocalizedString(@"시작해보세요.", nil);
    
    [self.gdLastBt1 setBackgroundImage:[BTColor imageWithCyanColor:1.0] forState:UIControlStateNormal];
    [self.gdLastBt1 setBackgroundImage:[BTColor imageWithCyanColor:0.85] forState:UIControlStateHighlighted];
    [self.gdLastBt1 setBackgroundImage:[BTColor imageWithCyanColor:0.85] forState:UIControlStateSelected];
    
    [self.gdLastBt2 setBackgroundImage:[BTColor imageWithSilverColor:0.2] forState:UIControlStateNormal];
    [self.gdLastBt2 setBackgroundImage:[BTColor imageWithSilverColor:0.1] forState:UIControlStateHighlighted];
    [self.gdLastBt2 setBackgroundImage:[BTColor imageWithSilverColor:0.1] forState:UIControlStateSelected];
    
    // If user already has a opened course
    BOOL hasOpenedCourse = [[BTUserDefault getUser] hasOpenedCourse];
    if (hasOpenedCourse) {
        self.gdLastBt1.frame = CGRectMake(90, 420, 140, 48);
        [self.gdLastBt1 setTitle:NSLocalizedString(@"계속하기", nil) forState:UIControlStateNormal];
        [self.gdLastBt1 addTarget:self action:@selector(closeGuide:) forControlEvents:UIControlEventTouchUpInside];
        self.gdLastBt2.hidden = YES;
    } else {
        [self.gdLastBt1 setTitle:NSLocalizedString(@"강의 개설하기", nil) forState:UIControlStateNormal];
        [self.gdLastBt1 addTarget:self action:@selector(createCourse:) forControlEvents:UIControlEventTouchUpInside];
        [self.gdLastBt2 setTitle:NSLocalizedString(@"수강하기", nil) forState:UIControlStateNormal];
        [self.gdLastBt2 addTarget:self action:@selector(attendCourse:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // Update UI for iPhone 4/4S
    if ([[UIScreen mainScreen] bounds].size.height < 568) {
        self.pageControl.frame = CGRectMake(125, 438, 71, 37);
        self.nextBt.frame = CGRectMake(265, 436, 40, 40);
        
        self.gdPollTitle.frame = CGRectMake(20, 20, 280, 29);
        self.gdPollImgBar.frame = CGRectMake(143, 62, 34, 4);
        self.gdPollMsg1.frame = CGRectMake(20, 88, 280, 18);
        self.gdPollMsg2.frame = CGRectMake(20, 114, 280, 18);
        self.gdPollMsg3.frame = CGRectMake(20, 140, 280, 18);
        self.gdPollImg.frame = CGRectMake(52, 155, 216, 216);
        self.showMorePoll.frame = CGRectMake(120, 395, 80, 35);
        
        self.gdAttdTitle.frame = CGRectMake(20, 20, 280, 29);
        self.gdAttdImgBar.frame = CGRectMake(143, 62, 34, 4);
        self.gdAttdMsg1.frame = CGRectMake(20, 88, 280, 18);
        self.gdAttdMsg2.frame = CGRectMake(20, 114, 280, 18);
        self.gdAttdMsg3.frame = CGRectMake(20, 140, 280, 18);
        self.gdAttdImg.frame = CGRectMake(52, 177, 218, 196);
        self.showMoreAttd.frame = CGRectMake(120, 395, 80, 35);
        
        self.gdNoticeTitle.frame = CGRectMake(20, 20, 280, 29);
        self.gdNoticeImgBar.frame = CGRectMake(143, 62, 34, 4);
        self.gdNoticeMsg1.frame = CGRectMake(20, 88, 280, 18);
        self.gdNoticeMsg2.frame = CGRectMake(20, 114, 280, 18);
        self.gdNoticeMsg3.frame = CGRectMake(20, 140, 280, 18);
        self.gdNoticeImg.frame = CGRectMake(52, 167, 218, 216);
        self.showMoreNotice.frame = CGRectMake(120, 395, 80, 35);
        
        self.gdLastImg.frame = CGRectMake(127, 44, 66, 66);
        self.gdLastMsg1.frame = CGRectMake(20, 146, 280, 30);
        self.gdLastMsg2.frame = CGRectMake(20, 184, 280, 30);
        self.gdLastMsg3.frame = CGRectMake(20, 226, 280, 30);
        self.gdLastBt1.frame = CGRectMake(90, 308, 140, 48);
        self.gdLastBt2.frame = CGRectMake(90, 370, 140, 48);
        
        if (hasOpenedCourse)
            self.gdLastBt1.frame = CGRectMake(90, 345, 140, 48);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    //all view component fade in
    self.pageControl.alpha = 0;
    self.closeBt.alpha = 0;
    self.nextBt.alpha = 0;
    self.swipeView.alpha = 0;
    self.guideFirstBG.alpha = 0;
    self.guidePollBG.alpha = 0;
    self.guideAttdBG.alpha = 0;
    self.guideNoticeBG.alpha = 0;
    self.guideLastBG.alpha = 0;
    [UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:1];
    self.pageControl.alpha = 1;
    self.closeBt.alpha = 1;
    self.nextBt.alpha = 1;
    self.swipeView.alpha = 1;
    
    if (self.swipeView.scrollOffset < 1)
        self.guideFirstBG.alpha = 1;
    else if (self.swipeView.scrollOffset < 2)
        self.guidePollBG.alpha = 1;
    else if (self.swipeView.scrollOffset < 3)
        self.guideAttdBG.alpha = 1;
    else if (self.swipeView.scrollOffset < 4)
        self.guideNoticeBG.alpha = 1;
    else
        self.guideLastBG.alpha = 1;
    
    [UIImageView commitAnimations];
    
    self.pageControl.pageIndicatorTintColor = [BTColor BT_grey:0.5];
    self.pageControl.currentPageIndicatorTintColor = [BTColor BT_white:0.8];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.statusBarAnim) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
}

#pragma SwipeViewDelegate
- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    self.pageControl.currentPage = swipeView.currentPage;
}

- (void)swipeViewDidScroll:(SwipeView *)swipeView
{
    if (swipeView.scrollOffset < 0) {
        self.guideFirstBG.alpha = 1.0;
        self.guidePollBG.alpha = 0.0;
        self.guideAttdBG.alpha = 0.0;
        self.guideNoticeBG.alpha = 0.0;
        self.guideLastBG.alpha = 0.0;
        self.nextBt.alpha = 1.0;
    }
    
    if (0 <= swipeView.scrollOffset && swipeView.scrollOffset < 1) {
        self.guideFirstBG.alpha = 1.0 - swipeView.scrollOffset;
        self.guidePollBG.alpha = swipeView.scrollOffset;
        self.guideAttdBG.alpha = 0.0;
        self.guideNoticeBG.alpha = 0.0;
        self.guideLastBG.alpha = 0.0;
        self.nextBt.alpha = 1.0;
    }
    
    if (1 <= swipeView.scrollOffset && swipeView.scrollOffset < 2) {
        self.guideFirstBG.alpha = 0.0;
        self.guidePollBG.alpha = 2.0 - swipeView.scrollOffset;
        self.guideAttdBG.alpha = swipeView.scrollOffset - 1.0;
        self.guideNoticeBG.alpha = 0.0;
        self.guideLastBG.alpha = 0.0;
        self.nextBt.alpha = 1.0;
    }
    
    if (2 <= swipeView.scrollOffset && swipeView.scrollOffset < 3) {
        self.guideFirstBG.alpha = 0.0;
        self.guidePollBG.alpha = 0.0;
        self.guideAttdBG.alpha = 3.0 - swipeView.scrollOffset;
        self.guideNoticeBG.alpha = swipeView.scrollOffset - 2.0;
        self.guideLastBG.alpha = 0.0;
        self.nextBt.alpha = 1.0;
    }
    
    if (3 <= swipeView.scrollOffset && swipeView.scrollOffset < 4) {
        self.guideFirstBG.alpha = 0.0;
        self.guidePollBG.alpha = 0.0;
        self.guideAttdBG.alpha = 0.0;
        self.guideNoticeBG.alpha = 4.0 - swipeView.scrollOffset;
        self.guideLastBG.alpha = swipeView.scrollOffset - 3.0;
        self.nextBt.alpha = 4.0 - swipeView.scrollOffset;
    }
    
    if (4 <= swipeView.scrollOffset) {
        self.guideFirstBG.alpha = 0.0;
        self.guidePollBG.alpha = 0.0;
        self.guideAttdBG.alpha = 0.0;
        self.guideNoticeBG.alpha = 0.0;
        self.guideLastBG.alpha = 1.0;
        self.nextBt.alpha = 0.0;
    }
    
    if (swipeView.scrollOffset < 3.5) {
        [self.closeBt setImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
        self.pageControl.pageIndicatorTintColor = [BTColor BT_white:0.5];
        self.pageControl.currentPageIndicatorTintColor = [BTColor BT_white:0.8];
    } else {
        [self.closeBt setImage:[UIImage imageNamed:@"x_black.png"] forState:UIControlStateNormal];
        self.pageControl.pageIndicatorTintColor = [BTColor BT_silver:0.5];
        self.pageControl.currentPageIndicatorTintColor = [BTColor BT_silver:0.8];
    }
}

#pragma IBAction
- (IBAction)closeGuide:(id)sender
{
    self.statusBarAnim = NO;
    self.pageControl.alpha = 1;
    self.closeBt.alpha = 1;
    self.nextBt.alpha = 1;
    self.swipeView.alpha = 1;
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.pageControl.alpha = 0;
        self.closeBt.alpha = 0;
        self.nextBt.alpha = 0;
        self.swipeView.alpha = 0;
        self.guideFirstBG.alpha = 0;
        self.guidePollBG.alpha = 0;
        self.guideAttdBG.alpha = 0;
        self.guideNoticeBG.alpha = 0;
        self.guideLastBG.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (IBAction)nextPage:(id)sender
{
    [self.swipeView scrollByNumberOfItems:1 duration:0.4];
}

- (IBAction)showTutorialPoll:(id)sender
{
    self.statusBarAnim = YES;
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *url = [NSString stringWithFormat:@"http://www.bttd.co/tutorial/clicker?device_type=iphone&locale=%@&app_version=%@", locale, appVersion];
    TutorialViewController *tutorial = [[TutorialViewController alloc] initWithURLString:url];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:tutorial] animated:YES completion:nil];
}

- (IBAction)showTutorialAttd:(id)sender
{
    self.statusBarAnim = YES;
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *url = [NSString stringWithFormat:@"http://www.bttd.co/tutorial/attendance?device_type=iphone&locale=%@&app_version=%@", locale, appVersion];
    TutorialViewController *tutorial = [[TutorialViewController alloc] initWithURLString:url];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:tutorial] animated:YES completion:nil];
}

- (IBAction)showTutorialNotice:(id)sender
{
    self.statusBarAnim = YES;
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *url = [NSString stringWithFormat:@"http://www.bttd.co/tutorial/notice?device_type=iphone&locale=%@&app_version=%@", locale, appVersion];
    TutorialViewController *tutorial = [[TutorialViewController alloc] initWithURLString:url];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:tutorial] animated:YES completion:nil];
}

#pragma SwipeViewDataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return 5;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    return [self viewAtIndex:index];
}

#pragma privateMethods
- (UIView *)viewAtIndex:(NSInteger) index
{
    switch (index) {
        case 0:
            return self.guideFirst;
        case 1:
            return self.guidePoll;
        case 2:
            return self.guideAttd;
        case 3:
            return self.guideNotice;
        case 4:
            return self.guideLast;
        default:
            break;
    }
    return nil;
}

- (void)createCourse:(id)selector {
    CourseCreateViewController *courseCreateView = [[CourseCreateViewController alloc] initWithNibName:@"CourseCreateViewController" bundle:nil];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[[UINavigationController alloc] initWithRootViewController:courseCreateView], ModalViewController, [NSNumber numberWithBool:YES], ModalViewAnim, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:OpenModalView object:nil userInfo:data];
    [self closeGuide:nil];
}

- (void)attendCourse:(id)selector {
    CourseAttendViewController *courseAttendView = [[CourseAttendViewController alloc] initWithNibName:@"CourseAttendViewController" bundle:nil];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[[UINavigationController alloc] initWithRootViewController:courseAttendView], ModalViewController, [NSNumber numberWithBool:YES], ModalViewAnim, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:OpenModalView object:nil userInfo:data];
    [self closeGuide:nil];
}

@end
