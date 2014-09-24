//
//  NoticeDetailListViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "NoticeDetailListViewController.h"
#import "BTAPIs.h"
#import "UIColor+Bttendance.h"
#import "StudentInfoCell.h"
#import "BTUserDefault.h"
#import "BTNotification.h"

@interface NoticeDetailListViewController ()

@end

@implementation NoticeDetailListViewController

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
    titlelabel.text = NSLocalizedString(@"Notice", nil);
    [titlelabel sizeToFit];
    
    [self.segmentcontrol setTitle:NSLocalizedString(@"이름순", nil) forSegmentAtIndex:0];
    [self.segmentcontrol setTitle:NSLocalizedString(@"학번순", nil) forSegmentAtIndex:1];
    [self.segmentcontrol setTitle:NSLocalizedString(@"확인순", nil) forSegmentAtIndex:2];
    
    data = [NSArray array];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        data = [NSMutableArray arrayWithArray:[BTUserDefault getStudentsOfArray:[NSString stringWithFormat:@"%ld", (long)self.post.course.id]]];
        [self right:nil];
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    });
    
    [BTAPIs studentsForCourse:[NSString stringWithFormat:@"%ld", (long)self.post.course.id]
                      success:^(NSArray *simpleUsers) {
                          data = simpleUsers;
                          switch (self.segmentcontrol.selectedSegmentIndex) {
                              case 0:
                                  [self left:nil];
                                  break;
                              case 1:
                                  [self center:nil];
                                  break;
                              case 2:
                              default:
                                  [self right:nil];
                                  break;
                          }
                          [self.tableview reloadData];
                      } failure:^(NSError *error) {
                      }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotice:) name:NoticeUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePost:) name:PostUpdated object:nil];
};

#pragma NSNotificationCenter
- (void)updateNotice:(NSNotification *)notification {
    if ([notification object] == nil)
        return;
    
    Notice *notice = [notification object];
    if (self.post.notice.id != notice.id)
        return;
    
    [self.post.notice copyDataFromNotice:notice];
    [self.tableview reloadData];
}

- (void)updatePost:(NSNotification *)notification {
    if ([notification object] == nil)
        return;
    
    Post *newPost = [notification object];
    if (self.post.id != newPost.id)
        return;
    
    self.post = newPost;
    [self.tableview reloadData];
}

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
    cell.idnumber.text = simpleUser.student_id;
    if([self.post.notice seen:simpleUser.id]) {
        cell.detail.text = NSLocalizedString(@"읽음", nil);
        [cell.icon setImage:[UIImage imageNamed:@"eye.png"]];
    } else {
        cell.detail.text = NSLocalizedString(@"읽지 않음", nil);
        [cell.icon setImage:[UIImage imageNamed:@"close_eye.png"]];
    }
    
    return cell;
}

#pragma IBAction
- (IBAction)left:(id)sender {
    self.segmentcontrol.selectedSegmentIndex = 0;
    
    NSArray *sorting = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [((SimpleUser *)a).full_name compare:((SimpleUser *)b).full_name options:NSNumericSearch];
    }];
    data = [NSArray arrayWithArray:sorting];
    
    [self.tableview reloadData];
}

- (IBAction)center:(id)sender {
    self.segmentcontrol.selectedSegmentIndex = 1;
    
    NSArray *sorting = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [((SimpleUser *)a).student_id compare:((SimpleUser *)b).student_id options:NSNumericSearch];
    }];
    data = [NSArray arrayWithArray:sorting];
    
    [self.tableview reloadData];
}

- (IBAction)right:(id)sender {
    self.segmentcontrol.selectedSegmentIndex = 2;
    
    NSArray *sorting1 = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [((SimpleUser *)a).full_name compare:((SimpleUser *)b).full_name options:NSNumericSearch];
    }];
    data = [NSArray arrayWithArray:sorting1];
    
    NSArray *sorting = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        BOOL second = [self.post.notice seen:((SimpleUser *)b).id];
        if (second)
            return (NSComparisonResult)NSOrderedAscending;
        else
            return (NSComparisonResult)NSOrderedDescending;
    }];
    data = [NSArray arrayWithArray:sorting];
    
    [self.tableview reloadData];
}

@end
