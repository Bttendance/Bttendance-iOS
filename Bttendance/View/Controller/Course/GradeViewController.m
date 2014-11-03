//
//  GradeView.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 28..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "GradeViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "GradeCell.h"
#import "BTAPIs.h"
#import "User.h"
#import "UIColor+Bttendance.h"

@interface GradeViewController ()

@end

@implementation GradeViewController
@synthesize cid;

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    rowcount = 0;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;

    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    
    if([self.type isEqualToString:@"attendance"]) {
        titlelabel.text = NSLocalizedString(@"Attendance Grades", nil);
        [titlelabel sizeToFit];
        
        [BTAPIs attendanceGradesWithCourse:cid success:^(NSArray *simpleUsers) {
            data = simpleUsers;
            rowcount = data.count;
            
            NSArray *sorting = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                return [((SimpleUser *)a).student_id compare:((SimpleUser *)b).student_id options:NSNumericSearch];
            }];
            data = [NSArray arrayWithArray:sorting];
            
            [self.tableView reloadData];
        } failure:^(NSError *error) {
        }];
    } else {
        titlelabel.text = NSLocalizedString(@"Clicker Grades", nil);
        [titlelabel sizeToFit];
        
        [BTAPIs clickerGradesWithCourse:cid success:^(NSArray *simpleUsers) {
            data = simpleUsers;
            rowcount = data.count;
            
            NSArray *sorting = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                return [((SimpleUser *)a).student_id compare:((SimpleUser *)b).student_id options:NSNumericSearch];
            }];
            data = [NSArray arrayWithArray:sorting];
            
            [self.tableView reloadData];
        } failure:^(NSError *error) {
        }];
    }
    
    self.tableView.backgroundColor = [UIColor grey:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowcount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"GradeCell";

    GradeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"GradeCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    SimpleUser *simpleUser = [data objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = simpleUser.full_name;
    cell.idnumber.text = simpleUser.student_id;
    NSArray *stringcomp = [simpleUser.grade componentsSeparatedByString:@"/"];
    cell.att.text = [stringcomp objectAtIndex:0];
    cell.tot.text = [stringcomp objectAtIndex:1];

    return cell;
}


@end
