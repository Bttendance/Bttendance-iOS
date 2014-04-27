//
//  CourseView.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 27..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "CourseAttendView.h"
#import "BTUserDefault.h"
#import "BTColor.h"
#import "BTAPIs.h"
#import "Course.h"
#import "School.h"

@interface CourseAttendView ()

@end

@implementation CourseAttendView
@synthesize sid;
@synthesize sname;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rowcount0 = 0;
        rowcount1 = 0;
        data0 = [[NSMutableArray alloc] init];
        data1 = [[NSMutableArray alloc] init];

        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 9.5, 15)];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    return self;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //set tableview background color
    [self tableview].backgroundColor = [BTColor BT_grey:1];

    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Attend Course", @"");
    [titlelabel sizeToFit];

    // Do any additional setup after loading the view from its nib.
    [BTAPIs coursesForSchool:[NSString stringWithFormat:@"%ld", (long) sid]
                     success:^(NSArray *courses) {
                         NSArray *attdcourse = [BTUserDefault getUser].attending_courses;
                         NSArray *supvcourse = [BTUserDefault getUser].supervising_courses;
                         
                         if (attdcourse.count != 0 || supvcourse.count != 0) {
                             for (int i = 0; i < courses.count; i++) {
                                 Boolean joined = false;
                                 for (int j = 0; j < attdcourse.count; j++) {
                                     NSInteger attd_int = ((Course *)attdcourse[j]).id;
                                     NSInteger course_int = ((Course *)[courses objectAtIndex:i]).id;
                                     
                                     if (attd_int == course_int) {
                                         joined = true;
                                         break;
                                     }
                                 }
                                 Boolean supved = false;
                                 for (int j = 0; j < supvcourse.count; j++) {
                                     NSInteger attd_int = ((Course *)supvcourse[j]).id;
                                     NSInteger course_int = ((Course *)[courses objectAtIndex:i]).id;
                                     
                                     if (attd_int == course_int) {
                                         supved = true;
                                         break;
                                     }
                                 }
                                 if (joined || supved)
                                     [data0 addObject:[courses objectAtIndex:i]];
                                 else
                                     [data1 addObject:[courses objectAtIndex:i]];
                             }
                             rowcount0 = data0.count;
                             rowcount1 = data1.count;
                             [self.tableview reloadData];
                         } else {
                             rowcount0 = 0;
                             for (int i = 0; i < courses.count; i++)
                                 [data1 addObject:[courses objectAtIndex:i]];
                             rowcount1 = data1.count;
                             [self.tableview reloadData];
                         }
                     } failure:^(NSError *error) {
                     }];
}

- (IBAction)check_button_action:(id)sender {

    UIButton *comingbutton = (UIButton *) sender;
    CourseInfoCell *comingcell = (CourseInfoCell *) comingbutton.superview.superview.superview;
    currentcell = comingcell;

    NSArray *enrolledSchools = [BTUserDefault getUser].enrolled_schools;
    BOOL hasBeenEnrolled = NO;
    for (int i = 0; i < [enrolledSchools count]; i++)
        if (((School *)enrolledSchools[i]).id == sid)
            hasBeenEnrolled = YES;

    if (hasBeenEnrolled) {
        NSString *string = [NSString stringWithFormat:@"%@ %@\n%@\n%@ ", comingcell.course.number, comingcell.course.name, comingcell.course.professor_name, comingcell.course.school.name];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Join Course" message:string delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
        [alert show];
    } else {
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Student ID or Phone Number"
                                                         message:[NSString stringWithFormat:@"Before you join course %@, you need to enter your student ID or your phone number", comingcell.Info_CourseName.text]
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Confirm", Nil];
        alert2.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert2 show];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return rowcount0;
        case 1:
        default:
            return rowcount1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Attending Courses";
        case 1:
        default:
            return @"Joinable Courses";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CourseInfoCell";

    CourseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseInfoCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    if (indexPath.section == 0) {
        cell.course = [data0 objectAtIndex:indexPath.row];
        cell.Info_ProfName.text = cell.course.professor_name;
        cell.Info_CourseName.text = cell.course.name;
        cell.backgroundColor = [BTColor BT_white:1];
        [cell.Info_Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 1) {
        cell.course = [data0 objectAtIndex:indexPath.row];
        cell.Info_ProfName.text = cell.course.professor_name;
        cell.Info_CourseName.text = cell.course.name;
        cell.backgroundColor = [BTColor BT_white:1];
        [cell.Info_Check setBackgroundImage:[UIImage imageNamed:@"enrolladd@2x.png"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.Info_Button addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {//cancel
        //restore button event
        [currentcell.Info_Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
        return;
    }

    if ([alertView alertViewStyle] == UIAlertViewStyleDefault) {
        [self attendCourse];
    }

    if ([alertView alertViewStyle] == UIAlertViewStylePlainTextInput) {

        [BTAPIs enrollSchool:[NSString stringWithFormat:@"%ld", sid]
                    identity:[[alertView textFieldAtIndex:0] text]
                     success:^(User *user) {
                         [self attendCourse];
                     } failure:^(NSError *error) {
                         NSString *string = @"Could not join course, please try again";
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                         message:string
                                                                        delegate:nil
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles:nil];
                         [alert show];
                     }];
    }
}

- (void)attendCourse {
    [BTAPIs attendCourse:[NSString stringWithFormat:@"%ld", (long) currentcell.course.id]
                 success:^(User *user) {
                     [[self tableview] beginUpdates];
                     [currentcell.Info_Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
                     rowcount1--;
                     rowcount0++;
                     NSIndexPath *comingcell_index = [[self tableview] indexPathForCell:currentcell];
                     for (int i = 0; i < [data1 count]; i++) {
                         if ([[[data1 objectAtIndex:i] objectForKey:@"id"] intValue] == currentcell.course.id) {
                             [data0 addObject:[data1 objectAtIndex:i]];
                             [data1 removeObjectAtIndex:i];
                             break;
                         }
                     }
                     [[self tableview] moveRowAtIndexPath:comingcell_index toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                     [[self tableview] endUpdates];
                 } failure:^(NSError *error) {
                     NSString *message = @"Could not attend current course, please try again";
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:message
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     [alert show];
                     [currentcell.Info_Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
                 }];
}

@end
