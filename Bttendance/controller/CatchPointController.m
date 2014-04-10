//
//  CatchPointController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "CatchPointController.h"


@interface CatchPointController ()

@end

@implementation CatchPointController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //gradient layer
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = _gradient.bounds;
    layer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], nil];
    [_gradient.layer insertSublayer:layer atIndex:0];

//    UIButtonType.UIButtonTypeRoundedRect
    //Navigation
    self.navigationController.title = @"Main";
    self.navigationController.navigationBarHidden = YES;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version >= 7){
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barTintColor = [BTColor BT_navy:1];
    }
    //button round
    _Signin.layer.cornerRadius = 3;
    _Signup.layer.cornerRadius = 3;
    
    //button setting
    
    //all view component fade in
    _btdtitle.alpha = 0;
    _subtitle.alpha = 0;
    _gradient.alpha = 0;
    _bgImage.alpha = 0;
    _Signup.alpha = 0;
    _Signin.alpha = 0;
    [UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:1];
    _btdtitle.alpha = 1;
    _subtitle.alpha = 1;
    _gradient.alpha = 1;
    _bgImage.alpha = 1;
    _Signup.alpha = 1;
    _Signin.alpha = 1;
    [UIImageView commitAnimations];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _Signup.backgroundColor = [UIColor colorWithRed:0.2 green:0.71 blue:0.898 alpha:0.7];
    _Signin.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.15 alpha:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)SignupButtonDown:(id)sender {
    _Signup.backgroundColor = [UIColor colorWithRed:0.2 green:0.71 blue:0.898 alpha:1];
}

- (IBAction)SigninButtonDown:(id)sender {
    _Signin.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.15 alpha:0.8];
}

- (IBAction)SignupButtonOutside:(id)sender {
    _Signup.backgroundColor = [UIColor colorWithRed:0.2 green:0.71 blue:0.898 alpha:0.7];
}

- (IBAction)SigninButtonOutside:(id)sender {
    _Signin.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.15 alpha:0.5];
}

-(IBAction)Signup_button:(id)sender{
    SignUpController *signUpController = [[SignUpController alloc] initWithNibName:@"SignUpController" bundle:nil];
    [self.navigationController pushViewController:signUpController animated:YES];
//    PersonalizeController *signUpController = [[PersonalizeController alloc] initWithNibName:@"PersonalizeController" bundle:nil];
//    [self.navigationController pushViewController:signUpController animated:YES];
    
//    [UIView transitionWithView:self.navigationController.view
//                      duration:0.75
//                       options:UIViewAnimationOptionTransitionCurlUp
//                    animations:^{
//                        [self.navigationController pushViewController:signUpController animated:NO];
//                    }
//                    completion:nil];
    
//    _Signup.backgroundColor = [UIColor colorWithRed:0.2 green:0.71 blue:0.898 alpha:1];
//    PersonalizeController *personalizeController = [[PersonalizeController alloc] initWithNibName:@"PersonalizeController" bundle:nil];
//    _btdtitle.alpha = 1;
//    _subtitle.alpha = 1;
//    _gradient.alpha = 1;
//    _bgImage.alpha = 1;
//    _Signup.alpha = 1;
//    _Signin.alpha = 1;
//    [UIImageView animateWithDuration:1 animations:^{
//        _btdtitle.alpha = 0;
//        _subtitle.alpha = 0;
//        _gradient.alpha = 0;
//        _bgImage.alpha = 0;
//        _Signup.alpha = 0;
//        _Signin.alpha = 0;
//    }completion:^(BOOL finished){
//        [self.navigationController pushViewController:personalizeController animated:NO];
//    }];
}

-(IBAction)Signin_button:(id)sender{
    
    NSLog(@"signin button pressed");
    
    _Signin.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.15 alpha:0.8];
    
    SignInController *signInController = [[SignInController alloc] initWithNibName:@"SignInController" bundle:nil];
    [self.navigationController pushViewController:signInController animated:YES];
    
//    [UIView transitionWithView:self.navigationController.view
//                      duration:1
//                       options:UIViewAnimationOptionTransitionCurlUp
//                    animations:^{
//                        [self.navigationController pushViewController:signInController animated:NO];
//                    }
//                    completion:nil];
    
}



@end
