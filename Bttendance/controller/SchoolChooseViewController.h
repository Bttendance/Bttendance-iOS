//
//  SchoolView.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 23..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolInfoCell.h"
#import "SchoolCreateViewController.h"

@protocol SchoolChooseViewControllerDelegate <NSObject>

@required
- (void)chosenSchool:(School *)chosen;
@end

@interface SchoolChooseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UISearchBarDelegate, SchoolCreateViewControllerDelegate> {
    
    NSUInteger sectionCount;
    NSUInteger rowcount0;
    NSUInteger rowcount1;
    
    NSMutableArray *sortedSchools;
    NSMutableArray *searchedSchools;
    
    NSMutableArray *data0;
    NSMutableArray *data1;

    NSDictionary *userinfo;

    SchoolInfoCell *currentcell;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) IBOutlet UIButton *createSchoolBt;
@property(strong, nonatomic) UISearchBar *searchbar;

@property (nonatomic, weak) id<SchoolChooseViewControllerDelegate> delegate;

- (IBAction)createSchool:(id)sender;

@end