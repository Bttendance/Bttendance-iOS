//
//  StudentConfirm.m
//  Bttendance
//
//  Created by HAJE on 2013. 12. 6..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "StudentConfirm.h"

@interface StudentConfirm ()

@end

@implementation StudentConfirm

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
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //gradient layer
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = _gradient.bounds;
    layer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], nil];
    [_gradient.layer insertSublayer:layer atIndex:0];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    _processButton.layer.cornerRadius = 3;
    _cancelbutton.layer.cornerRadius = 3;
    
    //all view component fade in
    _processButton.alpha = 0;
    _cancelbutton.alpha = 0;
    _gradient.alpha = 0;
    _Title.alpha = 0;
    _bgImage.alpha = 0;
    [UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:1];
    _processButton.alpha = 1;
    _cancelbutton.alpha = 1;
    _gradient.alpha = 1;
    _Title.alpha = 1;
    _bgImage.alpha = 1;
    [UIImageView commitAnimations];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    
    _processButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.71 blue:0.898 alpha:0.7];
    _cancelbutton.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.15 alpha:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)processButtondown:(id)sender {
    _processButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.71 blue:0.898 alpha:1];
}

- (IBAction)processButton:(id)sender {
    SignUpController *signUpController = [[SignUpController alloc] initWithNibName:@"SignUpController" bundle:nil];
    [self.navigationController pushViewController:signUpController animated:YES];

}

- (IBAction)processButtonOut:(id)sender {
    _processButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.71 blue:0.898 alpha:0.7];
}

- (IBAction)cancelButtondown:(id)sender {
    _cancelbutton.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.15 alpha:0.8];
}

- (IBAction)cancelButton:(id)sender {
    [UIImageView animateWithDuration:1 animations:^{
        _processButton.alpha = 0;
        _cancelbutton.alpha = 0;
        _gradient.alpha = 0;
        _Title.alpha = 0;
        _bgImage.alpha = 0;
    }completion:^(BOOL finished){
        [self.navigationController popViewControllerAnimated:NO];
    }];
    

}

- (IBAction)cancelButtonOut:(id)sender {
    _cancelbutton.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.15 alpha:0.5];
}
@end
