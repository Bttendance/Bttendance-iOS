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
    NSIndexPath *nameIndex;
    NSIndexPath *typeIndex;
    NSIndexPath *infoIndex;
}

@property (nonatomic, weak) id<SchoolCreateViewControllerDelegate> delegate;

@end
