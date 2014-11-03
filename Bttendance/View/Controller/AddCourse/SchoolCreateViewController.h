//
//  SchoolCreateViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 9..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "School.h"

@protocol SchoolCreateViewControllerDelegate <NSObject>

@required
- (void)createdSchool:(School *)created;
@end

@interface SchoolCreateViewController : UITableViewController <UITextFieldDelegate> {
    NSIndexPath *name_index;
    NSIndexPath *type_index;
    NSIndexPath *info_index;
}

@property (nonatomic, weak) id<SchoolCreateViewControllerDelegate> delegate;

@end
