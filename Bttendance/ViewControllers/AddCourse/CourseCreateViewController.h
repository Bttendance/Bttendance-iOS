//
//  SignUpController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolChooseViewController.h"

@interface CourseCreateViewController : UITableViewController <UITextFieldDelegate, SchoolChooseViewControllerDelegate> {
    NSIndexPath *name_index, *school_index, *profname_index;
}

@property(nonatomic) NSInteger schoolId;
@property(weak, nonatomic) NSString *schoolName;
@property(weak, nonatomic) NSString *prfName;

@end
