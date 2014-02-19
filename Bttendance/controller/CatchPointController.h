//
//  CatchPointController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpController.h"
#import "SignInController.h"
#import "PersonalizeController.h"

//@class SignInController;

@interface CatchPointController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *Signup;
@property (weak, nonatomic) IBOutlet UIButton *Signin;
@property (nonatomic, retain) IBOutlet UILabel *btdtitle;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UIImageView *gradient;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigation;

- (IBAction)SignupButtonDown:(id)sender;
- (IBAction)SigninButtonDown:(id)sender;
- (IBAction)SignupButtonOutside:(id)sender;
- (IBAction)SigninButtonOutside:(id)sender;


-(IBAction)Signup_button:(id)sender;
-(IBAction)Signin_button:(id)sender;
@end
