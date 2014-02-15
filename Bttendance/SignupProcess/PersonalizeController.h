//
//  PersonalizeController.h
//  Bttendance
//
//  Created by HAJE on 2013. 11. 22..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpController.h"
#import "SignInController.h"
#import "SerialViewController.h"
#import "StudentConfirm.h"
#import "BttendanceColor.h"

@interface PersonalizeController : UIViewController{
    NSArray *myBGImages;
    NSTimer *updateBG;
    UIViewController *background;
    
    int i;//for timer
    
    CGRect student_origin;
    CGRect prof_origin;
    
    CGRect student_cur;
    CGRect prof_cur;
    CGRect stdframe;
    CGRect profframe;
    
    CGFloat student_originX;
    CGFloat student_curX;
    CGFloat prof_originX;
    CGFloat prof_curX;
    
    UIPanGestureRecognizer *profpangr;
    UIPanGestureRecognizer *stdpangr;
    
    BOOL isfirst;
    
}
//
@property (weak, nonatomic) IBOutlet UIButton *student;
@property (weak, nonatomic) IBOutlet UIButton *professor;
@property (weak, nonatomic) IBOutlet UIButton *stdarrow;
@property (weak, nonatomic) IBOutlet UIButton *profarrow;

@property (weak, nonatomic) IBOutlet UIImageView *std;
@property (weak, nonatomic) IBOutlet UIImageView *prof;
@property (weak, nonatomic) IBOutlet UIButton *back;

@property (weak, nonatomic) IBOutlet UIImageView *back1;
@property (weak, nonatomic) IBOutlet UIImageView *back2;

@property (weak, nonatomic) IBOutlet UIImageView *gradient;
@property (weak, nonatomic) IBOutlet UIImageView *gradientR;

//
//-(void) studentMove:(id)sender withEvent:(UIEvent *)event;

@property (strong, nonatomic) SignUpController *signUpController;
@property (strong, nonatomic) SignInController *signInController;
@property (strong, nonatomic) SerialViewController *serial_InputController;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
- (IBAction)profButtonPressed:(id)sender;
- (IBAction)stdButtonPressed:(id)sender;

-(IBAction)goToSignin:(id)sender;
@end
