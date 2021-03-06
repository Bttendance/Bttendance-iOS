//
//  StudentListViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "StudentListViewController.h"
#import "StudentInfoCell.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import "UIColor+Bttendance.h"
#import "BTDatabase.h"

@interface StudentListViewController ()

@end

@implementation StudentListViewController

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    titlelabel.text = NSLocalizedString(@"Student List", nil);
    [titlelabel sizeToFit];
    
    data = [NSArray array];
    [BTDatabase getStudentsWithCourseID:self.course.id withData:^(NSArray *students) {
        data = students;
        [self.tableView reloadData];
    }];
    
    [BTAPIs studentsForCourse:[NSString stringWithFormat:@"%ld", (long)self.course.id]
                      success:^(NSArray *simpleUsers) {
                          data = simpleUsers;
                          
                          NSArray *sorting = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                              return [((SimpleUser *)a).studentID compare:((SimpleUser *)b).studentID options:NSNumericSearch];
                          }];
                          data = [NSArray arrayWithArray:sorting];
                          
                          [self.tableView reloadData];
                      } failure:^(NSError *error) {
                      }];
    
    self.tableView.backgroundColor = [UIColor grey:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
};

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"StudentInfoCell";
    
    StudentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    SimpleUser *simpleUser = [data objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = simpleUser.full_name;
    cell.idnumber.text = simpleUser.studentID;
    cell.detail.hidden = YES;
    cell.icon.hidden = YES;
    
    return cell;
}

@end
