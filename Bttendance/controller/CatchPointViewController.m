//
//  CatchPointController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "CatchPointViewController.h"
#import "SignUpViewController.h"
#import "SignInViewController.h"
#import "BTColor.h"

@interface CatchPointViewController ()

@end

@implementation CatchPointViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //gradient layer
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.gradient.bounds;
    layer.colors = [NSArray arrayWithObjects:(id) [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor], (id) [[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], nil];
    [self.gradient.layer insertSublayer:layer atIndex:0];

    //Navigation
    self.navigationController.title = @"";
    self.navigationController.navigationBarHidden = YES;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7) {
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barTintColor = [BTColor BT_navy:1];
    }

    //button localization
    self.Signup.titleLabel.text = NSLocalizedString(@"Sign Up", nil);
    self.Signin.titleLabel.text = NSLocalizedString(@"Log In", nil);
    self.btdtitle.text = NSLocalizedString(@"Bttendance", nil);
    self.subtitle.text = NSLocalizedString(@"Welcome to Bttendance", nil);

    //all view component fade in
    self.btdtitle.alpha = 0;
    self.subtitle.alpha = 0;
    self.gradient.alpha = 0;
    self.bgImage.alpha = 0;
    self.Signup.alpha = 0;
    self.Signin.alpha = 0;
    [UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:1];
    self.btdtitle.alpha = 1;
    self.subtitle.alpha = 1;
    self.gradient.alpha = 1;
    self.bgImage.alpha = 1;
    self.Signup.alpha = 1;
    self.Signin.alpha = 1;
    [UIImageView commitAnimations];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBarHidden = YES;
    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.Signup.backgroundColor = [UIColor colorWithRed:0.2 green:0.71 blue:0.898 alpha:0.7];
    self.Signin.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.15 alpha:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)SignupButtonDown:(id)sender {
    self.Signup.backgroundColor = [UIColor colorWithRed:0.2 green:0.71 blue:0.898 alpha:1];
}

- (IBAction)SigninButtonDown:(id)sender {
    self.Signin.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.15 alpha:0.8];
}

- (IBAction)SignupButtonOutside:(id)sender {
    self.Signup.backgroundColor = [UIColor colorWithRed:0.2 green:0.71 blue:0.898 alpha:0.7];
}

- (IBAction)SigninButtonOutside:(id)sender {
    self.Signin.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.15 alpha:0.5];
}

- (IBAction)Signup_button:(id)sender {
    SignUpViewController *signUpController = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [self.navigationController pushViewController:signUpController animated:YES];
}

- (IBAction)Signin_button:(id)sender {
    SignInViewController *signInController = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
    [self.navigationController pushViewController:signInController animated:YES];
}


@end
