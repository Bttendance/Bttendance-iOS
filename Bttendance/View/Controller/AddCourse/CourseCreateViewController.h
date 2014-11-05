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
    NSIndexPath *nameIndex;
    NSIndexPath *schoolIndex;
    NSIndexPath *profnameIndex;
}

@property(assign) NSInteger schoolId;
@property(nonatomic, retain) NSString *schoolName;
@property(nonatomic, retain) NSString *prfName;

@end
