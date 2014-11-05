//
//  SignUpController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface SignUpViewController : UITableViewController <UITextFieldDelegate, TTTAttributedLabelDelegate> {
    NSIndexPath *fullNameIndex, *emailIndex, *passwordIndex;
}
@end
