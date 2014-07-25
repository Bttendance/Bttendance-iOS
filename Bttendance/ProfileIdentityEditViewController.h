//
//  ProfileIdentityEditViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ViewController.h"
#import "Identification.h"

@interface ProfileIdentityEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(strong, nonatomic) SimpleIdentification *identification;
@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(strong, nonatomic) IBOutlet UITextField *identity_field;

- (void)save_identity;

@end
