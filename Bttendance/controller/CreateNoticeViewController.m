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
    // Do any additional setup after loading the view from its nib.
    post = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(post_Notice)];
    self.navigationItem.rightBarButtonItem = post;

    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Post Notice", @"");
    [titlelabel sizeToFit];

    _message.tintColor = [BTColor BT_silver:1];
}

- (void)viewDidAppear:(BOOL)animated {
    [_message becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)post_Notice {
    post.enabled = NO;
    [BTAPIs createNoticeWithCourse:cid
                           message:[self.message text] success:^(Post *post) {
                               [self.navigationController popViewControllerAnimated:YES];
                           } failure:^(NSError *error) {
                               post.enabled = YES;
                           }];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholder.hidden = textView.hasText;
}

@end
