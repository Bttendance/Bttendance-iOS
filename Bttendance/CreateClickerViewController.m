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
    start = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleDone target:self action:@selector(start_clicker)];
    self.navigationItem.rightBarButtonItem = start;
    
    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Start Clicker", @"");
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

- (void)start_clicker {
    start.enabled = NO;
    [BTAPIs startClickerWithCourse:cid
                           message:[self.message text]
                       choiceCount:@"4"
                           success:^(Post *post) {
                               [self.navigationController popViewControllerAnimated:YES];
                           } failure:^(NSError *error) {
                               start.enabled = YES;
                           }];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholder.hidden = textView.hasText;
}

@end
