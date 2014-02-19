//
//  NoticeView.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 28..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "CreateNoticeViewController.h"

@interface CreateNoticeViewController ()

@end

@implementation CreateNoticeViewController
@synthesize cid, currentcell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        userinfo = [BTUserDefault getUserInfo];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *post = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(post_Notice)];
    self.navigationItem.rightBarButtonItem = post;
    
    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Post Notice", @"");
    [titlelabel sizeToFit];
    
    _message.tintColor = [BTColor BT_silver:1];
    
    Cid = [NSString stringWithString:cid];
}

- (void)viewDidAppear:(BOOL)animated {
    [_message becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)post_Notice{
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSString *message = [self.message text];
    
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"course_id":self.cid,
                             @"message":message};
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
    [AFmanager POST:[BTURL stringByAppendingString:@"/post/create/notice"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self.navigationController popViewControllerAnimated:YES];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *string = @"Fails to made a notice, please try again";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];    
}

-(void)textViewDidChange:(UITextView *)textView{
    self.placeholder.hidden = textView.hasText;
}

@end
