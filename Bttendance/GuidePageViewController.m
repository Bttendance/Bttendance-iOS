//
//  GuideViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 7..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "GuidePageViewController.h"

@interface GuidePageViewController ()

@end

@implementation GuidePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.guideFirstBG = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
    self.guidePollBG = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
    self.guideAttdBG = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
    self.guideNoticeBG = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
    self.guideLastBG = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
    
    self.guideFirstBG.backgroundColor = [UIColor whiteColor];
    self.guidePollBG.backgroundColor = [UIColor yellowColor];
    self.guideAttdBG.backgroundColor = [UIColor greenColor];
    self.guideNoticeBG.backgroundColor = [UIColor purpleColor];
    self.guideLastBG.backgroundColor = [UIColor blackColor];
    
    self.guideFirstBG.alpha = 1.0;
    self.guidePollBG.alpha = 0.0;
    self.guideAttdBG.alpha = 0.0;
    self.guideNoticeBG.alpha = 0.0;
    self.guideLastBG.alpha = 0.0;
    
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
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
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
    }
    
    if (0 <= swipeView.scrollOffset && swipeView.scrollOffset < 1) {
        self.guideFirstBG.alpha = 1.0 - swipeView.scrollOffset;
        self.guidePollBG.alpha = swipeView.scrollOffset;
        self.guideAttdBG.alpha = 0.0;
        self.guideNoticeBG.alpha = 0.0;
        self.guideLastBG.alpha = 0.0;
    }
    
    if (1 <= swipeView.scrollOffset && swipeView.scrollOffset < 2) {
        self.guideFirstBG.alpha = 0.0;
        self.guidePollBG.alpha = 2.0 - swipeView.scrollOffset;
        self.guideAttdBG.alpha = swipeView.scrollOffset - 1.0;
        self.guideNoticeBG.alpha = 0.0;
        self.guideLastBG.alpha = 0.0;
    }
    
    if (2 <= swipeView.scrollOffset && swipeView.scrollOffset < 3) {
        self.guideFirstBG.alpha = 0.0;
        self.guidePollBG.alpha = 0.0;
        self.guideAttdBG.alpha = 3.0 - swipeView.scrollOffset;
        self.guideNoticeBG.alpha = swipeView.scrollOffset - 2.0;
        self.guideLastBG.alpha = 0.0;
    }
    
    if (3 <= swipeView.scrollOffset && swipeView.scrollOffset < 4) {
        self.guideFirstBG.alpha = 0.0;
        self.guidePollBG.alpha = 0.0;
        self.guideAttdBG.alpha = 0.0;
        self.guideNoticeBG.alpha = 4.0 - swipeView.scrollOffset;
        self.guideLastBG.alpha = swipeView.scrollOffset - 3.0;
    }
    
    if (4 < swipeView.scrollOffset) {
        self.guideFirstBG.alpha = 0.0;
        self.guidePollBG.alpha = 0.0;
        self.guideAttdBG.alpha = 0.0;
        self.guideNoticeBG.alpha = 0.0;
        self.guideLastBG.alpha = 1.0;
    }
}

#pragma IBAction
- (IBAction)closeGuide:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
