//
//  StdProfileEmailEditView.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileEmailEditViewController : UITableViewController <UITextFieldDelegate> {
    __weak NSString *email;
}

@property(weak, nonatomic) NSString *email;
@property(strong, nonatomic) IBOutlet UITextField *email_field;

- (void)save_email;

@end
