//
//  StdProfileNameEditView.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileNameEditViewController : UITableViewController <UITextFieldDelegate> {
    __weak NSString *fullname;
}

@property(weak, nonatomic) NSString *fullname;
@property(strong, nonatomic) IBOutlet UITextField *name_field;

- (void)save_fullname;

@end
