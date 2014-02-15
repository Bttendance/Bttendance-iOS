//
//  StudentConfirm.h
//  Bttendance
//
//  Created by HAJE on 2013. 12. 6..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpController.h"

@interface StudentConfirm : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *processButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelbutton;
@property (weak, nonatomic) IBOutlet UIImageView *gradient;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
- (IBAction)processButtondown:(id)sender;
- (IBAction)processButton:(id)sender;
- (IBAction)processButtonOut:(id)sender;
- (IBAction)cancelButtondown:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (IBAction)cancelButtonOut:(id)sender;

@end
