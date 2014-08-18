//
//  NoticeView.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 28..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "CreateNoticeViewController.h"
#import "BTUserDefault.h"
#import <AFNetworking/AFNetworking.h>
#import "BTAPIs.h"
#import "BTColor.h"
#import "BTNotification.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AudioToolbox/AudioServices.h>

@interface CreateNoticeViewController ()

@end

@implementation CreateNoticeViewController
@synthesize cid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    return self;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *post = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Post", nil) style:UIBarButtonItemStyleDone target:self action:@selector(post_Notice:)];
    self.navigationItem.rightBarButtonItem = post;

    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Notice", @"");
    [titlelabel sizeToFit];

    _message.tintColor = [BTColor BT_silver:1];
    
    Course *course = [BTUserDefault getCourse:[cid integerValue]];
    self.information.text = [NSString stringWithFormat:NSLocalizedString(@"* %d명의 학생이 공지를 받게 됩니다.\n* 어떤 학생이 읽지 않았는지 확인할 수 있습니다.", nil), 20];
    self.information.numberOfLines = 0;
    [self.information sizeToFit];

    self.placeholder.text = NSLocalizedString(@"Write an announcement.", nil);
}

- (void)viewDidAppear:(BOOL)animated {
    [_message becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)post_Notice:(UIBarButtonItem *)sender  {
    sender.enabled = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Posting Notice", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs createNoticeWithCourse:cid
                           message:[self.message text] success:^(Post *post) {
                               [hud hide:YES];
                               NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:post, PostInfo, nil];
                               [[NSNotificationCenter defaultCenter] postNotificationName:OpenNewPost object:nil userInfo:data];
                               [self.navigationController popViewControllerAnimated:NO];
                           } failure:^(NSError *error) {
                               [hud hide:YES];
                               sender.enabled = YES;
                           }];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholder.hidden = textView.hasText;
}

@end
