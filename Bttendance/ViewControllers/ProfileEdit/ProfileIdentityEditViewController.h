//
//  ProfileIdentityEditViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Identification.h"

@interface ProfileIdentityEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(strong, nonatomic) SimpleIdentification *identification;
@property(assign) NSInteger schoolID;
@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(strong, nonatomic) IBOutlet UITextField *identity_field;

- (void)save_identity;

@end
