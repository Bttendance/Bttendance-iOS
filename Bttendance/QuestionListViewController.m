//
//  QuestionListViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "QuestionListViewController.h"
#import "BTColor.h"
#import "BTUserDefault.h"
#import "BTAPIs.h"

@interface QuestionListViewController ()

@property (strong) NSArray *questions;

@end

@implementation QuestionListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [BTColor BT_white:1.0];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Edit Email", @"");
    [titlelabel sizeToFit];
    
    self.questions = [BTUserDefault getQuestions];
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.questions == nil)
        return 0;
    
    return [self.questions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
