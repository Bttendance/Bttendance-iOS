//
//  GuideViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 7..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "GuidePageViewController.h"
#import "BTColor.h"

@interface GuidePageViewController ()

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
    
    self.gdFirstTitle.text = NSLocalizedString(@"가입을 환영합니다!", nil);
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
    self.showMorePoll.layer.masksToBounds = YES;
    
    self.showMoreAttd.titleLabel.text = NSLocalizedString(@"더 알아보기", nil);
    self.showMoreAttd.layer.cornerRadius = 3.0;
    self.showMoreAttd.layer.borderWidth = 1.2;
    self.showMoreAttd.layer.borderColor = [BTColor BT_white:1.0].CGColor;
    self.showMoreAttd.layer.masksToBounds = YES;
    
    self.showMoreNotice.titleLabel.text = NSLocalizedString(@"더 알아보기", nil);
    self.showMoreNotice.layer.cornerRadius = 3.0;
    self.showMoreNotice.layer.borderWidth = 1.2;
    self.showMoreNotice.layer.borderColor = [BTColor BT_white:1.0].CGColor;
    self.showMoreNotice.layer.masksToBounds = YES;
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
    self.guideFirstBG.alpha = 1;
    [UIImageView commitAnimations];
    
    self.pageControl.pageIndicatorTintColor = [BTColor BT_black:0.7];
    self.pageControl.currentPageIndicatorTintColor = [BTColor BT_silver:0.7];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
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
}

#pragma IBAction
- (IBAction)closeGuide:(id)sender
{
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

@end
