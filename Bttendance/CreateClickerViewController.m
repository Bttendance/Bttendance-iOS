//
//  CreateClickerViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 29..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "CreateClickerViewController.h"
#import "BTUserDefault.h"
#import <AFNetworking/AFNetworking.h>
#import "BTAPIs.h"
#import "BTColor.h"

@interface CreateClickerViewController ()

@end

@implementation CreateClickerViewController
@synthesize cid;

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *start = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleDone target:self action:@selector(start_clicker)];
    self.navigationItem.rightBarButtonItem = start;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    //Navigation title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Clicker", @"");
    [titlelabel sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated {
//    [_message becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification Handlers
- (void)keyboardDidShow:(NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.view setFrame:CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - kbSize.height - 64)];
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self.view setFrame:CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - 64)];
    [self.view layoutIfNeeded];
}

- (void)start_clicker {
//    start.enabled = NO;
//    [BTAPIs startClickerWithCourse:cid
//                           message:[self.message text]
//                       choiceCount:@"4"
//                           success:^(Post *post) {
//                               [self.navigationController popViewControllerAnimated:YES];
//                           } failure:^(NSError *error) {
//                               start.enabled = YES;
//                           }];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

#pragma IBAction
- (void)loadQuestion:(id)sender {
    
}

@end
