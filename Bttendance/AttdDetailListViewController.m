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
#import "SocketAgent.h"

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
                          
                          SimpleUser *user1 = [[SimpleUser alloc] init];
                          user1.id = 1;
                          user1.full_name = @"Ashley";
                          user1.student_id = @"20140005";
                          
                          SimpleUser *user2 = [[SimpleUser alloc] init];
                          user2.id = 2;
                          user2.full_name = @"William";
                          user2.student_id = @"20140014";
                          
                          SimpleUser *user3 = [[SimpleUser alloc] init];
                          user3.id = 3;
                          user3.full_name = @"Victoria";
                          user3.student_id = @"20140003";
                          
                          SimpleUser *user4 = [[SimpleUser alloc] init];
                          user4.id = 4;
                          user4.full_name = @"Francois";
                          user4.student_id = @"20140012";
                          
                          SimpleUser *user5 = [[SimpleUser alloc] init];
                          user5.id = 5;
                          user5.full_name = @"Tae Hwan";
                          user5.student_id = @"20140001";
                          
                          SimpleUser *user6 = [[SimpleUser alloc] init];
                          user6.id = 6;
                          user6.full_name = @"Xiao Long";
                          user6.student_id = @"20140015";
                          
                          SimpleUser *user7 = [[SimpleUser alloc] init];
                          user7.id = 7;
                          user7.full_name = @"Ichiro";
                          user7.student_id = @"20140004";
                          
                          SimpleUser *user8 = [[SimpleUser alloc] init];
                          user8.id = 8;
                          user8.full_name = @"Muhammad";
                          user8.student_id = @"20140013";
                          
                          SimpleUser *user9 = [[SimpleUser alloc] init];
                          user9.id = 9;
                          user9.full_name = @"Hee Hwan";
                          user9.student_id = @"20140002";
                          
                          SimpleUser *user10 = [[SimpleUser alloc] init];
                          user10.id = 10;
                          user10.full_name = @"Runfa";
                          user10.student_id = @"20140011";
                          
                          SimpleUser *user11 = [[SimpleUser alloc] init];
                          user11.id = 11;
                          user11.full_name = @"Arthur";
                          user11.student_id = @"20140010";
                          
                          SimpleUser *user12 = [[SimpleUser alloc] init];
                          user12.id = 12;
                          user12.full_name = @"Lancelot";
                          user12.student_id = @"20140019";
                          
                          SimpleUser *user13 = [[SimpleUser alloc] init];
                          user13.id = 13;
                          user13.full_name = @"Roland";
                          user13.student_id = @"20140008";
                          
                          SimpleUser *user14 = [[SimpleUser alloc] init];
                          user14.id = 14;
                          user14.full_name = @"Harry Potter";
                          user14.student_id = @"20140017";
                          
                          SimpleUser *user15 = [[SimpleUser alloc] init];
                          user15.id = 15;
                          user15.full_name = @"Mario";
                          user15.student_id = @"20140006";
                          
                          SimpleUser *user16 = [[SimpleUser alloc] init];
                          user16.id = 16;
                          user16.full_name = @"Alberto";
                          user16.student_id = @"20140020";
                          
                          SimpleUser *user17 = [[SimpleUser alloc] init];
                          user17.id = 17;
                          user17.full_name = @"Mustapa";
                          user17.student_id = @"20140009";
                          
                          SimpleUser *user18 = [[SimpleUser alloc] init];
                          user18.id = 18;
                          user18.full_name = @"Diego";
                          user18.student_id = @"20140018";
                          
                          SimpleUser *user19 = [[SimpleUser alloc] init];
                          user19.id = 19;
                          user19.full_name = @"Su Hyang";
                          user19.student_id = @"20140007";
                          
                          SimpleUser *user20 = [[SimpleUser alloc] init];
                          user20.id = 20;
                          user20.full_name = @"Goku";
                          user20.student_id = @"20140016";
                          
                          simpleUsers = [NSArray arrayWithObjects:user1, user2, user3, user4, user5, user6, user7, user8, user9, user10, user11, user12, user13, user14, user15, user16, user17, user18, user19, user20, nil];
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
    
    [[SocketAgent sharedInstance] socketConnect];
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
    [self.post.attendance toggleStatus:simpleUser.id];
    [self.tableview reloadData];
    
    [BTAPIs toggleManuallyWithAttendance:[NSString stringWithFormat:@"%ld", (long)self.post.attendance.id]
                                    user:[NSString stringWithFormat:@"%ld", (long)simpleUser.id]
                                 success:^(Attendance *attendance) {
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
