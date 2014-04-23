//
//  SignUpController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCreateController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSIndexPath *name_index, *number_index, *school_index, *profname_index;
    NSDictionary *user_info;
    NSInteger schoolId;
    __weak NSString *schoolName;
    __weak NSString *prfName;
}


//@property (retain, nonatomic) IBOutlet UINavigationItem *navigation;

@property(strong, nonatomic) IBOutlet UIButton *create;
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) NSInteger schoolId;
@property(weak, nonatomic) NSString *schoolName;
@property(weak, nonatomic) NSString *prfName;

@end
