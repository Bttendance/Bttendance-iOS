//
//  StdCourseView.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 15..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "CourseListViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "SocketIOPacket.h"
#import "BTUserDefault.h"
#import "BTUUID.h"
#import "BTColor.h"
#import "CourseCell.h"
#import "CourseDetailViewController.h"
#import "BTAPIs.h"
#import "SchoolChooseView.h"
#import "BTDateFormatter.h"
#import "CreateNoticeViewController.h"
#import "CreateClickerViewController.h"
#import "Course.h"
#import "BTNotification.h"

@interface CourseListViewController ()

@end

@implementation CourseListViewController

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];

    if (self) {
        data = [[NSMutableArray alloc] init];
        user = [BTUserDefault getUser];
        attdingPostIDs = [[NSMutableArray alloc] init];

        myservice = [BTUUID getUserService];
        myCmanager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        [myPmanager addService:myservice];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCourses:) name:@"NEWMESSAGE" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

        socketIO = [[SocketIO alloc] initWithDelegate:self];
        //        [socketIO connectToHost:@"bttendance-dev.herokuapp.com" onPort:0];
//        [socketIO connectToHost:@"localhost" onPort:1337 withParams:params withNamespace:@"api/clickers/click"];
        [socketIO connectToHost:@"localhost" onPort:1337];

        UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13.5, 13.5)];
        [plusButton addTarget:self action:@selector(plusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"plus@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *plusButtonItem = [[UIBarButtonItem alloc] initWithCustomView:plusButton];
        [self.navigationItem setRightBarButtonItem:plusButtonItem];
    }

    return self;
}

- (void)socketIODidConnect:(SocketIO *)socket {
    NSLog(@"Connected to %@", socket.host);
    [socket sendMessage:@"Hello"];
}

- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"Disconnected : %@", socket.host);
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    NSLog(@"didReceiveEvent : %@", [packet dataAsJSON]);

    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"onConnect"]) {

        NSString *username = [BTUserDefault getUsername];
        NSString *password = [BTUserDefault getPassword];
        NSString *socketId = [[[packet dataAsJSON] objectForKey:@"args"][0] objectForKey:@"socketId"];

        NSDictionary *params = @{@"username" : username,
                @"password" : password,
                @"socket_id" : socketId,
                @"clicker_id" : @"1"};

        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
        [AFmanager POST:@"http://localhost:1337/api/clickers/connect" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject : %@", responseObject);
        }       failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        }];
    }

    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"clickers"]) {
        NSLog(@"clickers : %@", [[[packet dataAsJSON] objectForKey:@"args"][0] objectForKey:@"data"]);
    }
}

- (void)socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet {
    NSLog(@"didReceiveJSON : %@", packet);
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {
    NSLog(@"didReceiveMessage : %@", packet);
}

- (void)plusButtonPressed:(id)aResponder {
    NSLog(@"plusButtonPressed");

//    NSDictionary *params = @{@"post_id":@"1",
//                             @"clicker_id":@"1"};
//    
//    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
//    [AFmanager PUT:@"http://localhost:1337/api/clickers/click" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
//        NSLog(@"responseObject : %@", responseObject);
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
//        
    //    }];

//    SIAlertView *message = [[SIAlertView alloc] initWithTitle:nil
//                                                   andMessage:nil];
//
//    [message addButtonWithTitle:@"Create Course"
//                           type:SIAlertViewButtonTypeDefault
//                        handler:^(SIAlertView *alert) {
//                            [self move_to_school:YES];
//                          }];
//    [message addButtonWithTitle:@"Attend Course"
//                           type:SIAlertViewButtonTypeDefault
//                        handler:^(SIAlertView *alert) {
//                              [self move_to_school:NO];
//                          }];
//    [message addButtonWithTitle:@"Cancel"
//                           type:SIAlertViewButtonTypeDestructive
//                        handler:nil];
//
//    message.transitionStyle = SIAlertViewTransitionStyleFade;
//    message.buttonsListStyle = SIAlertViewButtonsListStyleRows;
//    
//    message.backgroundColor = [BTColor BT_black:0.2];
//    message.messageColor = [BTColor BT_grey:1];
//    message.destructiveButtonColor = [BTColor BT_white:1];
//    message.shadowRadius = 0;
//    
//    [message dismissAnimated:NO];
//    
//    [message show];

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
            initWithTitle:@""
                 delegate:self
        cancelButtonTitle:@"Cancel"
   destructiveButtonTitle:nil
        otherButtonTitles:@"Create Course", @"Attend Course", nil];
    [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
}

- (void)appDidEnterForeground:(NSNotification *)notification {
    [self.tableview reloadData];
//    [self checkAttdScan];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [BTColor BT_grey:1];
    [self tableview].backgroundColor = [BTColor BT_grey:1];
    [self refreshUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:UserUpdated object:nil];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UserUpdated object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshUser];
    [self.tableview reloadData];
    [self refreshCourses:nil];
}

- (void)reloadTableView:(NSNotification *)noti {
    [self.tableview reloadData];
}

- (void)refreshCourses:(id)sender {
//    [BTAPIs coursesInSuccess:^(NSArray *courses) {
//        data = courses;
//        [self checkAttdScan];
//        [self.tableview reloadData];
//    } failure:^(NSError *error) {
//    }];
}

- (void)refreshUser {
    user = [BTUserDefault getUser];
    rowcount1 = [user.supervising_courses count];
    rowcount2 = [user.attending_courses count];
    sectionCount = 0;
    if (rowcount1 > 0)
        sectionCount++;
    if (rowcount2 > 0)
        sectionCount++;
    
    if (sectionCount == 0)
        _noCourseView.hidden = NO;
    else
        _noCourseView.hidden = YES;
}

#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (sectionCount == 2) {
        switch (section) {
            case 0:
                return @"Supervising Courses";
            case 1:
            default:
                return @"Attending Courses";
        }
    } else if (sectionCount == 1) {
        if (rowcount1 > 0)
            return @"Supervising Courses";
        else
            return @"Attending Courses";
    } else
        return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (sectionCount == 2) {
        switch (section) {
            case 0:
                return rowcount1;
            case 1:
            default:
                return rowcount2;
        }
    } else if (sectionCount == 1) {
        if (rowcount1 > 0)
            return rowcount1;
        else
            return rowcount2;
    } else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (sectionCount == 2) {
        switch (indexPath.section) {
            case 0:
                return [self supervisingCellWith:tableView at:indexPath.row];
            case 1:
            default:
                return [self attendingCellWith:tableView at:indexPath.row];
        }
    } else if (sectionCount == 1) {
        if (rowcount1 > 0)
            return [self supervisingCellWith:tableView at:indexPath.row];
        else
            return [self attendingCellWith:tableView at:indexPath.row];
    } else
        return nil;
}

- (UITableViewCell *)supervisingCellWith:(UITableView *)tableView at:(NSInteger)rowIndex {

    static NSString *CellIdentifier = @"CourseCell";

    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (data.count != 0) {
        for (int i = 0; i < data.count; i++) {
            if (((SimpleCourse *)[user.supervising_courses objectAtIndex:rowIndex]).id ==
                    ((Course *)[data objectAtIndex:i]).id) {
                cell.course = [data objectAtIndex:i];
                cell.CourseName.text = cell.course.name;
                cell.Professor.text = cell.course.professor_name;
                cell.School.text = cell.course.school.name;
                cell.cellbackground.layer.cornerRadius = 2;
                cell.isManager = true;
                [cell.background setFrame:CGRectMake(239, 75 - [cell.course.grade integerValue] / 2, 50, [cell.course.grade integerValue] / 2)];

                [cell.attendanceBt addTarget:self action:@selector(attdStart:) forControlEvents:UIControlEventTouchUpInside];
                [cell.clickerBt addTarget:self action:@selector(clickerStart:) forControlEvents:UIControlEventTouchUpInside];
                [cell.noticeBt addTarget:self action:@selector(createNotice:) forControlEvents:UIControlEventTouchUpInside];

                cell.gap = [cell.course.attdCheckedAt timeIntervalSinceNow];
                if (180.0f + cell.gap > 0.0f) {
                    [self startAnimation:cell];
                } else if (cell.blink != nil) {
                    cell.check_icon.alpha = 1;
                    [cell.blink invalidate];
                    cell.blink = nil;
                }

                break;
            }
        }
    } else {
        cell.simpleCourse = [user.supervising_courses objectAtIndex:rowIndex];
        for (int i = 0; i < [user.employed_schools count]; i++)
            if (((SimpleSchool *)user.employed_schools[i]).id == cell.simpleCourse.school)
                cell.School.text = ((SimpleSchool *)user.employed_schools[i]).name;
        cell.CourseName.text = cell.simpleCourse.name;
        cell.Professor.text = cell.simpleCourse.professor_name;
        cell.cellbackground.layer.cornerRadius = 2;
        cell.isManager = true;
        [cell.background setFrame:CGRectMake(239, 75 - [cell.course.grade integerValue] / 2, 50, [cell.course.grade integerValue] / 2)];
        
        [cell.attendanceBt addTarget:self action:@selector(attdStart:) forControlEvents:UIControlEventTouchUpInside];
        [cell.clickerBt addTarget:self action:@selector(clickerStart:) forControlEvents:UIControlEventTouchUpInside];
        [cell.noticeBt addTarget:self action:@selector(createNotice:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (UITableViewCell *)attendingCellWith:(UITableView *)tableView at:(NSInteger)rowIndex {

    static NSString *CellIdentifier = @"CourseCell";

    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (data.count != 0) {
        for (int i = 0; i < data.count; i++) {
            if (((SimpleCourse *)[user.attending_courses objectAtIndex:rowIndex]).id ==
                ((Course *)[data objectAtIndex:i]).id) {
                cell.course = [data objectAtIndex:i];
                cell.CourseName.text = cell.course.name;
                cell.Professor.text = cell.course.professor_name;
                cell.School.text = cell.course.school.name;
                cell.cellbackground.layer.cornerRadius = 2;
                cell.isManager = false;
                [cell.background setFrame:CGRectMake(239, 75, 50, 0)];

                [cell.attendanceBt removeTarget:self action:@selector(attdStart:) forControlEvents:UIControlEventTouchUpInside];
                [cell.clickerBt removeTarget:self action:@selector(clickerStart:) forControlEvents:UIControlEventTouchUpInside];
                [cell.noticeBt removeTarget:self action:@selector(createNotice:) forControlEvents:UIControlEventTouchUpInside];

                cell.gap = [cell.course.attdCheckedAt timeIntervalSinceNow];
                if (180.0f + cell.gap > 0.0f) {
                    [self startAnimation:cell];
                } else if (cell.blink != nil) {
                    cell.check_icon.alpha = 1;
                    [cell.blink invalidate];
                    cell.blink = nil;
                }

                break;
            }
        }
    } else {
        cell.simpleCourse = [user.attending_courses objectAtIndex:rowIndex];
        for (int i = 0; i < [user.enrolled_schools count]; i++)
            if (((SimpleSchool *)user.enrolled_schools[i]).id == cell.simpleCourse.school)
                cell.School.text = ((SimpleSchool *)user.enrolled_schools[i]).name;
        cell.CourseName.text = cell.simpleCourse.name;
        cell.Professor.text = cell.simpleCourse.professor_name;
        cell.cellbackground.layer.cornerRadius = 2;
        cell.isManager = true;
        [cell.background setFrame:CGRectMake(239, 75, 50, 0)];
        
        [cell.attendanceBt removeTarget:self action:@selector(attdStart:) forControlEvents:UIControlEventTouchUpInside];
        [cell.clickerBt removeTarget:self action:@selector(clickerStart:) forControlEvents:UIControlEventTouchUpInside];
        [cell.noticeBt removeTarget:self action:@selector(createNotice:) forControlEvents:UIControlEventTouchUpInside];
    }

    cell.attendanceBt.hidden = YES;
    cell.clickerBt.hidden = YES;
    cell.noticeBt.hidden = YES;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (sectionCount == 2) {
        switch (indexPath.section) {
            case 0:
                return 146.0f;
            case 1:
            default:
                return 102.0f;
        }
    } else if (sectionCount == 1) {
        if (rowcount1 > 0)
            return 146.0f;
        else
            return 102.0f;
    } else
        return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCell *cell = (CourseCell *) [self.tableview cellForRowAtIndexPath:indexPath];
    CourseDetailViewController *courseDetailViewController = [[CourseDetailViewController alloc] initWithNibName:@"CourseDetailViewController" bundle:nil];
    courseDetailViewController.currentcell = cell;

    if (indexPath.section == 0) {
        courseDetailViewController.auth = YES;
    } else {
        courseDetailViewController.auth = NO;
    }

    [self.navigationController pushViewController:courseDetailViewController animated:YES];
}

#pragma Course Button Animation
- (void)startAnimation:(CourseCell *)cell {

    float height = (180.0f + cell.gap) / 180.0f * 50.0f;
    cell.background.frame = CGRectMake(239, 75 - height, 50, height);
    [cell.check_button removeTarget:self action:@selector(attdStart:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:180.0f + cell.gap
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [cell.background setFrame:CGRectMake(239, 75, 50, 0)];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [cell.background setFrame:CGRectMake(239, 75 - [cell.course.grade integerValue] / 2, 50, [cell.course.grade integerValue] / 2)];
                             if (cell.isManager)
                                 [cell.check_button addTarget:self action:@selector(attdStart:) forControlEvents:UIControlEventTouchUpInside];
                         }
                     }];

    cell.blinkTime = 180 + cell.gap;
    if (cell.blink != nil)
        [cell.blink invalidate];
    NSTimer *blink = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(blink:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:cell, @"cell", nil] repeats:YES];
    cell.blink = blink;
}

- (void)blink:(NSTimer *)timer {
    CourseCell *cell = [[timer userInfo] objectForKey:@"cell"];

    cell.blinkTime--;
    if (cell.blinkTime < 0) {
        cell.check_icon.alpha = 1;
        if (cell.blink != nil)
            [cell.blink invalidate];
        cell.blink = nil;
        return;
    }

    if (cell.check_icon.alpha < 0.5) {
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:1.0];
        cell.check_icon.alpha = 1;
        [UIImageView commitAnimations];
    } else {
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:1.0];
        cell.check_icon.alpha = 0;
        [UIImageView commitAnimations];
    }
}

#pragma Button Events
- (void)move_to_school:(BOOL)auth {
    SchoolChooseView *schoolChooseView = [[SchoolChooseView alloc] init];
    schoolChooseView.auth = auth;
    [self.navigationController pushViewController:schoolChooseView animated:YES];
}

- (void)attdStart:(id)sender {
    UIButton *send = (UIButton *) sender;
    CourseCell *cell = (CourseCell *) send.superview.superview.superview;
    attdStartingCid = [NSString stringWithFormat:@"%ld", (long) cell.course.id];

    UIAlertView *alert;
    switch ([myCmanager state]) {
        case CBCentralManagerStatePoweredOn: //power-on
            alert = [[UIAlertView alloc] initWithTitle:cell.CourseName.text message:@"Do you wish to start attendance check?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
            break;
        case CBCentralManagerStatePoweredOff: //powered off
            alert = [[UIAlertView alloc] initWithTitle:@"Turn On Bluetooth" message:@"Your bluetooth is powered off. Before start Attedance check turn your bluetooth on." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            break;
        case CBCentralManagerStateUnknown: //Unknown state
        case CBCentralManagerStateUnsupported: //Bluetooth Low Energy not supported
        case CBCentralManagerStateUnauthorized: //Bluetooth Low Energy not authorized
        default: //default
            alert = [[UIAlertView alloc] initWithTitle:@"Device Unsupported" message:@"Your device doesn't support proper bluetooth version." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            break;
    }
    [alert show];
}

- (void)clickerStart:(id)sender {
    UIButton *send = (UIButton *) sender;
    CourseCell *cell = (CourseCell *) send.superview.superview.superview;
    
    CreateClickerViewController *clickerView = [[CreateClickerViewController alloc] initWithNibName:@"CreateClickerViewController" bundle:nil];
    if (cell.course != nil)
        clickerView.cid = [NSString stringWithFormat:@"%ld", (long) cell.course.id];
    else
        clickerView.cid = [NSString stringWithFormat:@"%ld", (long) cell.simpleCourse.id];
    clickerView.currentcell = cell;
    [self.navigationController pushViewController:clickerView animated:YES];
}

- (void)createNotice:(id)sender {
    UIButton *send = (UIButton *) sender;
    CourseCell *cell = (CourseCell *) send.superview.superview.superview;

    CreateNoticeViewController *noticeView = [[CreateNoticeViewController alloc] initWithNibName:@"CreateNoticeViewController" bundle:nil];
    if (cell.course != nil)
        noticeView.cid = [NSString stringWithFormat:@"%ld", (long) cell.course.id];
    else
        noticeView.cid = [NSString stringWithFormat:@"%ld", (long) cell.simpleCourse.id];
    noticeView.currentcell = cell;
    [self.navigationController pushViewController:noticeView animated:YES];
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && [myCmanager state] == CBCentralManagerStatePoweredOn)
        [self startAttdCheck];

    if (buttonIndex == 0 && [myCmanager state] == CBCentralManagerStatePoweredOff)
        myPmanager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self move_to_school:YES];
            break;
        case 1:
            [self move_to_school:NO];
            break;
        case 2:
        default:
            break;
    }
}

#pragma Attendance Check Events
- (void)startAttdCheck {
    [BTAPIs startAttendanceWithCourse:attdStartingCid
                              success:^(Post *post) {
                                  [self startAttdCheck];
                              } failure:^(NSError *error) {
                              }];
}

- (void)checkAttdScan {
    //Attendance Start Check
    [attdingPostIDs removeAllObjects];
    for (int i = 0; i < data.count; i++) {
        Course *course = [data objectAtIndex:i];
        int gap = [course.attdCheckedAt timeIntervalSinceNow];
        if (180.0f + gap > 0.0f) {
//            NSArray *posts = [[data objectAtIndex:i] objectForKey:@"posts"];
//            NSNumber *maxID = [posts valueForKeyPath:@"@max.intValue"];
//            [attdingPostIDs addObject:maxID];
        }
    }

    //Attendance Start
    if ([attdingPostIDs count] > 0)
        [self startAttdScan];
}

- (void)startAttdScan {
    UIAlertView *alert;
    switch ([myCmanager state]) {
        case CBCentralManagerStatePoweredOn: { //power-on
            myPmanager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
            [myCmanager scanForPeripheralsWithServices:nil options:nil];
            break;
        }
        case CBCentralManagerStatePoweredOff: //powered off
            alert = [[UIAlertView alloc] initWithTitle:@"Turn On Bluetooth" message:@"Your bluetooth is powered off. Currently, attedance check is in progress. Please turn your bluetooth on." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case CBCentralManagerStateUnknown: //Unknown state
        case CBCentralManagerStateUnsupported: //Bluetooth Low Energy not supported
        case CBCentralManagerStateUnauthorized: //Bluetooth Low Energy not authorized
        default: //default
            alert = [[UIAlertView alloc] initWithTitle:@"Device Unsupported" message:@"Your device doesn't support proper bluetooth version." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            break;
    }
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *uuid = [BTUUID representativeString:[[advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey] objectAtIndex:0]];
    NSLog(@"Found %@", uuid);

    for (int i = 0; i < [attdingPostIDs count]; i++) {
        [BTAPIs foundDeviceWithAttendance:[[attdingPostIDs objectAtIndex:i] stringValue]
                                     uuid:uuid
                                  success:^(Attendance *attendance) {
                                  } failure:^(NSError *error) {
                                  }];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSString *state = nil;
    switch ([central state]) {
        case CBCentralManagerStateUnsupported:
            state = @"The platform hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            [self checkAttdScan];
            state = @"power-on";
            break;
        case CBCentralManagerStateUnknown:
            state = @"Unknown state";
            break;
        default:
            state = @"default";
            break;
    }
    NSLog(@"Central STATE : %@", state);
}

#pragma mark - CBPeripheralDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSString *state = nil;
    switch ([peripheral state]) {
        case CBPeripheralManagerStateUnsupported:
            state = @"The platform hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBPeripheralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBPeripheralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBPeripheralManagerStatePoweredOn:
            [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey : @[myservice.UUID]}];
            state = @"power-on";
            break;
        case CBPeripheralManagerStateUnknown:
            state = @"Unknown state";
            break;
        default:
            state = @"default";
            break;
    }
    NSLog(@"Peripheral STATE : %@", state);
}

@end
