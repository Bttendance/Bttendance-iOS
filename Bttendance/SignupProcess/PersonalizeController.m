//
//  PersonalizeController.m
//  Bttendance
//
//  Created by HAJE on 2013. 11. 22..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "PersonalizeController.h"
#import <QuartzCore/QuartzCore.h>

@interface PersonalizeController ()

@end

@implementation PersonalizeController
@synthesize back1, back2;
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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //gradient layer
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = _gradient.bounds;
    layer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], nil];
    [_gradient.layer insertSublayer:layer atIndex:0];
    
    CAGradientLayer *layerR = [CAGradientLayer layer];
    layerR.frame = _gradientR.bounds;
    layerR.colors = [NSArray arrayWithObjects:(id)[[BTColor BT_Red:1] CGColor],(id)[[BTColor BT_Red:0] CGColor], nil];

    [layerR setStartPoint:CGPointMake(0.0, 0.5)];
    [layerR setEndPoint:CGPointMake(1.0, 0.5)];

    [_gradientR.layer insertSublayer:layerR atIndex:0];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    
    back1.alpha = 0;
    [UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:1];
    back1.alpha = 1;
    [self.view addSubview:back1];
    [UIImageView commitAnimations];
    
    back2.alpha = 0;
    [self.view addSubview:back2];
    [self.view bringSubviewToFront:_gradient];
    [self.view bringSubviewToFront:_gradientR];
    [self.view bringSubviewToFront:_Title];
    [self.view bringSubviewToFront:_subTitle];
    updateBG = [NSTimer scheduledTimerWithTimeInterval:(1) target:self selector:@selector(changeImage) userInfo:nil repeats:YES];

    //--------------------------------------//
    
    //------ personalize drag gesture ------//
    stdpangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_student addGestureRecognizer:stdpangr];
    student_originX = _student.frame.origin.x;
    student_origin = _student.frame;
    [self.view bringSubviewToFront:_std];
    _std.alpha = 0;
    _student.alpha =0;
    _stdarrow.alpha = 0;
    _std.backgroundColor = [UIColor clearColor];
    _student.backgroundColor = [UIColor clearColor];
    _stdarrow.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:_student];
    [self.view bringSubviewToFront:_stdarrow];

    
    profpangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_professor addGestureRecognizer:profpangr];
    prof_originX = _professor.frame.origin.x;
    prof_origin = _professor.frame;
    [self.view bringSubviewToFront:_prof];
    _prof.alpha = 0;
    _professor.alpha = 0;
    _profarrow.alpha = 0;
    _professor.backgroundColor = [UIColor clearColor];
    _prof.backgroundColor = [UIColor clearColor];
    _profarrow.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:_professor];
    [self.view bringSubviewToFront:_profarrow];
    
    //--------------------------------------//
    _std.layer.cornerRadius = 102;
    _std.layer.masksToBounds = YES;
    _prof.layer.cornerRadius = 102;
    _prof.layer.masksToBounds = YES;
    
    _back.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Already have an account?" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    _back.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    
    [self.view bringSubviewToFront:_back];
    isfirst = false;
    
    [self.view bringSubviewToFront:_gradient];
    [self.view bringSubviewToFront:_gradientR];
    [self.view bringSubviewToFront:_Title];
    [self.view bringSubviewToFront:_subTitle];
}

- (void) viewDidAppear:(BOOL)animated{
    if (!isfirst) {
        _Title.alpha=0;
        _subTitle.alpha = 0;
        _std.alpha = 0;
        _student.alpha = 0;
        _stdarrow.alpha = 0;
        _professor.alpha = 0;
        _prof.alpha = 0;
        _profarrow.alpha = 0;
        _gradient.alpha = 0;
        _gradientR.alpha = 0;
        _back.alpha = 0;
        back1.alpha = 0;
        back2.alpha =0;
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:1];
        _Title.alpha = 1;
        _subTitle.alpha = 1;
        _std.alpha = 1;
        _prof.alpha = 1;
        _student.alpha = 1;
        _professor.alpha = 1;
        _profarrow.alpha = 1;
        _stdarrow.alpha = 1;
        _gradient.alpha = 1;
        _gradientR.alpha = 1;
        _back.alpha = 1;
        back1.alpha = 1;
        [UIImageView commitAnimations];

    }
    else{
        _Title.alpha = 0;
        _subTitle.alpha = 0;
        _std.alpha = 0;
        _prof.alpha = 0;
        back1.alpha = 0;
        _student.alpha = 0;
        _professor.alpha = 0;
        _profarrow.alpha = 0;
        _stdarrow.alpha = 0;
        _gradient.alpha = 0;
        _gradientR.alpha = 0;
        _back.alpha = 0;
        back1.alpha =0;
        back2.alpha =0;
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:1];
        _Title.alpha = 1;
        _subTitle.alpha = 1;
        _std.alpha = 1;
        _prof.alpha = 1;
        back1.alpha = 1;
        _student.alpha = 1;
        _professor.alpha = 1;
        _profarrow.alpha = 1;
        _stdarrow.alpha = 1;
        _gradient.alpha = 1;
        _gradientR.alpha = 1;
        _back.alpha = 1;
        back1.alpha = 1;
        [UIImageView commitAnimations];
    }

    if(!updateBG){
        updateBG = [NSTimer scheduledTimerWithTimeInterval:(1) target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    }
    isfirst = false;
    
}

-(void) viewWillAppear:(BOOL)animated{

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    _std.alpha = 0;
    _prof.alpha = 0;
    back1.alpha = 0;
    back2.alpha = 0;
    _gradientR.alpha = 0;
    _gradient.alpha = 0;
    _Title.alpha = 0;
    _subTitle.alpha = 0;
    _student.alpha = 0;
    _stdarrow.alpha = 0;
    _professor.alpha = 0;
    _profarrow.alpha = 0;
    _std.layer.cornerRadius = 102;
    _prof.layer.cornerRadius = 102;
    _back.alpha = 0;
    [back1 stopAnimating];
    [back2 stopAnimating];
    back1.alpha =0;
    back2.alpha =0;
    [updateBG invalidate];
    updateBG = nil;
    isfirst = true;
    i = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeImage{
//    i=1;
    if (i == 16){
        i=0;
    }
    switch (i) {
        case 6:
            back1.alpha = 1;
            [UIImageView beginAnimations:nil context:NULL];
            [UIImageView setAnimationDuration:1];
            back1.alpha = 0;
            [UIImageView commitAnimations];
            i++;
            break;
        case 7:
            back2.alpha = 0;
            [UIImageView beginAnimations:nil context:NULL];
            [UIImageView setAnimationDuration:1];
            back2.alpha = 1;
            [UIImageView commitAnimations];
            i++;
            break;
        case 14:
            back2.alpha = 1;
            [UIImageView beginAnimations:nil context:NULL];
            [UIImageView setAnimationDuration:1];
            back2.alpha = 0;
            [UIImageView commitAnimations];
            i++;
            break;
        case 15:
            back1.alpha = 0;
            [UIImageView beginAnimations:nil context:NULL];
            [UIImageView setAnimationDuration:1];
            back1.alpha = 1;
            [UIImageView commitAnimations];
            i++;
            break;
        default:
            i++;
            break;
    }
}

- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan){
        //get origin frame
        stdframe = _std.frame;
        profframe = _prof.frame;
        
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged){

        UIView *draggedButton = recognizer.view;
        CGPoint translation = [recognizer translationInView:self.view];
        CGRect newButtonFrame = draggedButton.frame;
        
        newButtonFrame.origin.x += translation.x;
//        draggedButton.frame = newButtonFrame;     //button move
        student_cur = newButtonFrame;
        [recognizer setTranslation:CGPointZero inView:self.view];
        CGFloat std_scaleW = _std.frame.size.width-(translation.x)*1.8;
        CGFloat std_scaleH = _std.frame.size.height-(translation.x*1.8);
        CGFloat prf_scaleW = _prof.frame.size.width+(translation.x)*1.8;
        CGFloat prf_scaleH = _prof.frame.size.height+(translation.x)*1.8;
        
        if(draggedButton == _student){
            _std.frame = CGRectMake(_std.frame.origin.x + translation.x, _std.frame.origin.y + translation.x, std_scaleW, std_scaleH);
            _std.layer.cornerRadius = std_scaleW / 2;
//            NSLog(@"std image current size : %f", std_scaleW);
            if (std_scaleW < 204) {
                _std.frame = CGRectMake(218, 335, 204, 204);
            }
            
            if(std_scaleW >=400){
                [_student removeGestureRecognizer:stdpangr];
                _std.frame = CGRectMake(_std.frame.origin.x, _std.frame.origin.y, std_scaleW, std_scaleH);
                _std.layer.cornerRadius = _std.frame.size.width/2;
                [UIImageView beginAnimations:nil context:NULL];
                [UIImageView setAnimationDuration:1];
                _std.frame = CGRectMake(-250, -40, 800, 800);
                [UIImageView commitAnimations];
                
                [self performSelector:@selector(std_confirm) withObject:nil afterDelay:1];
            }
        }
        
        if(draggedButton == _professor){
            _prof.frame = CGRectMake(_prof.frame.origin.x, _prof.frame.origin.y - translation.x ,prf_scaleW, prf_scaleH);
            _prof.layer.cornerRadius = prf_scaleW / 2;
//            NSLog(@"prof image current size : %f", prf_scaleH);
//            NSLog(@"position %f %f",_prof.frame.origin.x, _prof.frame.origin.y);
            if (prf_scaleW < 204) {
                _prof.frame = CGRectMake(-102, 335, 204, 204);
            }
            
            if(prf_scaleH >=400){
                [_professor removeGestureRecognizer:profpangr];
                _prof.frame = CGRectMake(_prof.frame.origin.x, _prof.frame.origin.y, prf_scaleW, prf_scaleH);
                _prof.layer.cornerRadius = _prof.frame.size.height/2;
                [UIImageView beginAnimations:nil context:NULL];
                [UIImageView setAnimationDuration:1];
                _prof.frame = CGRectMake(-250, -40, 800, 800);
                [UIImageView commitAnimations];
                
                [self performSelector:@selector(prf_confirm) withObject:nil afterDelay:1];
            }
        }
    }
    
    else if(recognizer.state == UIGestureRecognizerStateEnded){
        UIView *draggedButton = recognizer.view;

        CGRect newButtonFrame = draggedButton.frame;
        
        if(draggedButton == _student){
            newButtonFrame.origin.x = student_originX;
            student_curX = student_originX;
            _std.frame = stdframe;
            _std.layer.cornerRadius = 102;

            
        }
        if(draggedButton == _professor){
            newButtonFrame.origin.x = prof_originX;
            prof_curX = prof_originX;
            _prof.frame = profframe;
            _prof.layer.cornerRadius = 102;

            
        }
        
        draggedButton.frame = newButtonFrame;
        [recognizer setTranslation:CGPointZero inView:self.view];
        
        
    }

}

-(void)std_confirm{//go to student confirm view
    [_student addGestureRecognizer:stdpangr]; //add gesture recognizer
    [back1 stopAnimating];
    [back2 stopAnimating];
    _prof.alpha = 0;
    back1.alpha = 0;
    back2.alpha = 0;
    _professor.alpha = 0;
    _profarrow.alpha = 0;
    _gradient.alpha = 0;
    _gradientR.alpha = 0;
    StudentConfirm *studentConfirm = [[StudentConfirm alloc] initWithNibName:@"StudentConfirm" bundle:nil];
    [UIImageView animateWithDuration:1 animations:^{
        _Title.alpha = 0;
        _subTitle.alpha = 0;
        _std.alpha = 0;
        _back.alpha = 0;
        _student.alpha = 0;
        _stdarrow.alpha = 0;
    }completion:^(BOOL finished){
        [self.navigationController pushViewController:studentConfirm animated:NO];
    }];
}

-(void)prf_confirm{//go to serial view
    [_professor addGestureRecognizer:profpangr]; //add gesture recognizer
    
    SerialViewController *serialViewController = [[SerialViewController alloc] initWithNibName:@"SerialViewController" bundle:nil];
    serialViewController.isSignUp = true;
    [self.navigationController pushViewController:serialViewController animated:YES];
}

- (IBAction)profButtonPressed:(id)sender {
    [self.view bringSubviewToFront:_prof];
    [self.view bringSubviewToFront:_profarrow];
    [self.view bringSubviewToFront:_professor];
    [self.view bringSubviewToFront:_Title];
    [self.view bringSubviewToFront:_subTitle];
    _professor.titleLabel.alpha = 1;
    
}

- (IBAction)stdButtonPressed:(id)sender {
    [self.view bringSubviewToFront:_std];
    [self.view bringSubviewToFront:_stdarrow];
    [self.view bringSubviewToFront:_student];
    [self.view bringSubviewToFront:_Title];
    [self.view bringSubviewToFront:_subTitle];
    _student.titleLabel.alpha = 1;
}

-(IBAction)goToSignin:(id)sender{
    _std.alpha = 0;

    SignInController *signInController = [[SignInController alloc] initWithNibName:@"SignInController" bundle:nil];
    [self.navigationController pushViewController:signInController animated:YES];
}


@end
