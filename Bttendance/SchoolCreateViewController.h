//
//  SchoolCreateViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 9..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ViewController.h"
#import "School.h"

@protocol SchoolCreateViewControllerDelegate <NSObject>

@required
- (void)createdSchool:(School *)created;
@end

@interface SchoolCreateViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSIndexPath *name_index;
}

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<SchoolCreateViewControllerDelegate> delegate;

@end
