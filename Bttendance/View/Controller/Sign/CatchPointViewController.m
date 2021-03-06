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
#import "UIColor+Bttendance.h"
#import "UIImage+Bttendance.h"
#import "SocketAgent.h"

@interface CatchPointViewController ()

@end

@implementation CatchPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //gradient layer
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.gradient.bounds;
    layer.colors = [NSArray arrayWithObjects:(id) [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor],
                    (id) [[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], nil];
    [self.gradient.layer insertSublayer:layer atIndex:0];

    //button localization
    [self.Signup setTitle:NSLocalizedString(@"Sign Up", nil) forState:UIControlStateNormal];
    [self.Signin setTitle:NSLocalizedString(@"Log In", nil) forState:UIControlStateNormal];
    self.btdtitle.text = NSLocalizedString(@"BTTENDANCE", nil);
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
    
    [self.Signup setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.7]] forState:UIControlStateNormal];
    [self.Signup setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:1.0]] forState:UIControlStateHighlighted];
    
    [self.Signin setBackgroundImage:[UIImage imageWithColor:[UIColor black:0.5]] forState:UIControlStateNormal];
    [self.Signin setBackgroundImage:[UIImage imageWithColor:[UIColor black:0.8]] forState:UIControlStateHighlighted];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (IBAction)Signup_button:(id)sender {
    SignUpViewController *signUpController = [[SignUpViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:signUpController animated:YES];
}

- (IBAction)Signin_button:(id)sender {
    SignInViewController *signInController = [[SignInViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:signInController animated:YES];
}


@end
