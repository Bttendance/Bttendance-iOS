//
//  AttdDetailListViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "AttdDetailListViewController.h"
#import "BTAPIs.h"
#import "BTColor.h"
#import "StudentInfoCell.h"
#import "BTUserDefault.h"
#import "BTNotification.h"

@interface AttdDetailListViewController ()

@end

@implementation AttdDetailListViewController

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Attendance Check", nil);
    [titlelabel sizeToFit];
    
    [self.segmentcontrol setTitle:NSLocalizedString(@"이름순", nil) forSegmentAtIndex:0];
    [self.segmentcontrol setTitle:NSLocalizedString(@"학번순", nil) forSegmentAtIndex:1];
    [self.segmentcontrol setTitle:NSLocalizedString(@"출석순", nil) forSegmentAtIndex:2];
    
    data = [NSArray array];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        data = [NSMutableArray arrayWithArray:[BTUserDefault getStudentsOfArray:[NSString stringWithFormat:@"%ld", (long)self.post.course.id]]];
        if (self.start)
            [self center: nil];
        else
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAttendance:) name:AttendanceUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePost:) name:PostUpdated object:nil];
};

#pragma NSNotificationCenter
- (void)updateAttendance:(NSNotification *)notification {
    if ([notification object] == nil)
        return;
    
    Attendance *attendance = [notification object];
    if (self.post.attendance.id != attendance.id)
        return;
    
    [self.post.attendance copyDataFromAttendance:attendance];
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
    return data.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIFont *cellfont = [UIFont systemFontOfSize:12];
        NSString *rawmessage = NSLocalizedString(@"학생의 이름을 누르면 학생의 출결 상황이 결석 -> 출석 -> 지각 -> 결석 순으로 바뀝니다.", nil);
        NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
        CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){280, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        return ceil(MessageLabelSize.size.height) + 14;
    }
    return 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UIFont *cellfont = [UIFont systemFontOfSize:12];
        NSString *rawmessage = NSLocalizedString(@"학생의 이름을 누르면 학생의 출결 상황이 결석 -> 출석 -> 지각 -> 결석 순으로 바뀝니다.", nil);
        NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
        CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){280, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, ceil(MessageLabelSize.size.height) + 10)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_grey:1];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 280, 0)];
        label.textColor = [BTColor BT_silver:1];
        label.font = [UIFont systemFontOfSize:12];
        label.text = rawmessage;
        label.numberOfLines = 0;
        [label sizeToFit];
        
        [cell addSubview:label];
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"StudentInfoCell";
        
        StudentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        SimpleUser *simpleUser = [data objectAtIndex:indexPath.row - 1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.name.text = simpleUser.full_name;
        cell.idnumber.text = simpleUser.student_id;
        cell.underline.hidden = YES;
        switch ([self.post.attendance stateInt:simpleUser.id]) {
            case 1:
                cell.detail.text = NSLocalizedString(@"출석", nil);
                [cell.icon setImage:[UIImage imageNamed:@"checked.png"]];
                cell.background_bg.backgroundColor = [BTColor BT_navy:0.1];
                cell.selected_bg.backgroundColor = [BTColor BT_navy:0.15];
                break;
            case 2:
                cell.detail.text = NSLocalizedString(@"지각", nil);
                [cell.icon setImage:[UIImage imageNamed:@"late.png"]];
                cell.background_bg.backgroundColor = [BTColor BT_cyan:0.1];
                cell.selected_bg.backgroundColor = [BTColor BT_cyan:0.15];
                break;
            default:
                cell.detail.text = NSLocalizedString(@"결석", nil);
                [cell.icon setImage:[UIImage imageNamed:@"absent.png"]];
                cell.background_bg.backgroundColor = [BTColor BT_silver:0.1];
                cell.selected_bg.backgroundColor = [BTColor BT_silver:0.15];
                break;
        };
        
        return cell;
    }
}

//#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
        return;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SimpleUser *simpleUser = [data objectAtIndex:indexPath.row - 1];
    [BTAPIs toggleManuallyWithAttendance:[NSString stringWithFormat:@"%ld", (long)self.post.attendance.id]
                                    user:[NSString stringWithFormat:@"%ld", (long)simpleUser.id]
                                 success:^(Attendance *attendance) {
                                     [self.post.attendance copyDataFromAttendance:attendance];
                                     [self.tableview reloadData];
                                 } failure:^(NSError *error) {
                                 }];
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
        NSInteger first = [self.post.attendance stateInt:((SimpleUser *)a).id];
        NSInteger second = [self.post.attendance stateInt:((SimpleUser *)b).id];
        
        if (first == 1)
            first = 2;
        else if (first == 2)
            first = 1;
        
        if (second == 1)
            second = 2;
        else if (second == 2)
            second = 1;
        
        if (first > second)
            return (NSComparisonResult)NSOrderedDescending;
        else
            return (NSComparisonResult)NSOrderedAscending;
    }];
    data = [NSArray arrayWithArray:sorting];
    
    [self.tableview reloadData];
}

@end
