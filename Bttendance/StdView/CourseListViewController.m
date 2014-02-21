//
//  StdCourseView.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "CourseListViewController.h"

@interface CourseListViewController ()

@end

@implementation CourseListViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        data = [[NSMutableArray alloc] init];
        userinfo = [BTUserDefault getUserInfo];
        supervisingCourses = [userinfo objectForKey:SupervisingCoursesKey];
        attendingCourses = [userinfo objectForKey:AttendingCoursesKey];
        attdingPostIDs = [[NSMutableArray alloc] init];
        
        myservice = [BTUserDefault getUserService];
        myCmanager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        [myPmanager addService:myservice];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCourses:) name:@"NEWMESSAGE" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return self;
}

- (void)appDidEnterForeground:(NSNotification *)notification {
    [self.tableview reloadData];
    [self checkAttdScan];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [BTColor BT_grey:1];
    [self tableview].backgroundColor = [BTColor BT_grey:1];
    
    rowcount1 = 1;
    rowcount2 = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview reloadData];
    [self refreshCourses:nil];
}

-(void)refreshCourses:(id)sender{
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSString *uuid = [userinfo objectForKey:UUIDKey];
    
    NSDictionary *params_ = @{@"username":username,
                              @"password":password};
    
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"device_uuid":uuid};
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager GET:[BTURL stringByAppendingString:@"/user/auto/signin"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [BTUserDefault setUserInfo:responseObject];
        [AFmanager GET:[BTURL stringByAppendingString:@"/user/courses"] parameters:params_ success:^(AFHTTPRequestOperation *operation, id responseObject){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            userinfo = [BTUserDefault getUserInfo];
            supervisingCourses = [userinfo objectForKey:SupervisingCoursesKey];
            attendingCourses = [userinfo objectForKey:AttendingCoursesKey];
            rowcount1 = [supervisingCourses count] + 1;
            rowcount2 = [attendingCourses count] + 1;
            data = responseObject;
            [self checkAttdScan];
            [self.tableview reloadData];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Supervising Courses";
        case 1:
        default:
            return @"Attending Courses";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return rowcount1;
        case 1:
        default:
            return rowcount2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            if (rowcount1 == 1 || indexPath.row == [supervisingCourses count]) {
                
                static NSString *CellIdentifier1 = @"ButtonCell";
                ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
                
                if(cell == nil){
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ButtonCell" owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [BTColor BT_grey:1];
                [cell.button addTarget:self action:@selector(move_to_school:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            } else {
                
                static NSString *CellIdentifier = @"CourseCell";
                
                CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(cell == nil){
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if(data.count != 0){
                    for (int i = 0 ; i< data.count; i++){
                        if( [[supervisingCourses objectAtIndex:indexPath.row] intValue] ==
                           [[[data objectAtIndex:i] objectForKey:@"id"] intValue]){
                            cell.CourseName.text = [[data objectAtIndex:i] objectForKey:@"name"];
                            cell.Professor.text = [[data objectAtIndex:i] objectForKey:@"professor_name"];
                            cell.School.text = [[data objectAtIndex:i] objectForKey:@"school_name"];
                            cell.CourseID = [[[data objectAtIndex:i] objectForKey:@"id"] intValue];
                            cell.grade = [[[data objectAtIndex:i] objectForKey:@"grade"] intValue];
                            cell.cellbackground.layer.cornerRadius = 2;
                            cell.isManager = true;
                            [cell.check_button addTarget:self action:@selector(attdStart:) forControlEvents:UIControlEventTouchUpInside];
                            [cell.background setFrame:CGRectMake(239, 75 - cell.grade / 2, 50, cell.grade / 2)];
                            
                            NSString *attdCheckedAt = [[data objectAtIndex:i] objectForKey:@"attdCheckedAt"];
                            cell.attdCheckedDate = [BTDateFormatter dateFromUTC:attdCheckedAt];
                            cell.gap = [BTDateFormatter intervalFromUTC:attdCheckedAt];
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
                }
                return cell;
            }
        case 1:
        default:
            if (rowcount2 == 1 || indexPath.row == [attendingCourses count]) {
                static NSString *CellIdentifier1 = @"ButtonCell";
                ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
                
                if(cell == nil){
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ButtonCell" owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [BTColor BT_grey:1];
                [cell.button addTarget:self action:@selector(move_to_school:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            } else {
                static NSString *CellIdentifier = @"CourseCell";
                
                CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(cell == nil){
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if(data.count != 0){
                    for(int i = 0; i< data.count; i++){
                        if( [[attendingCourses objectAtIndex:indexPath.row] intValue] ==
                           [[[data objectAtIndex:i] objectForKey:@"id"] intValue]){
                            cell.CourseName.text = [[data objectAtIndex:i] objectForKey:@"name"];
                            cell.Professor.text = [[data objectAtIndex:i] objectForKey:@"professor_name"];
                            cell.School.text = [[data objectAtIndex:i] objectForKey:@"school_name"];
                            cell.CourseID = [[[data objectAtIndex:i] objectForKey:@"id"] intValue];
                            cell.grade = [[[data objectAtIndex:i] objectForKey:@"grade"] intValue];
                            cell.cellbackground.layer.cornerRadius = 2;
                            cell.isManager = false;
                            [cell.check_button removeTarget:self action:@selector(attdStart:) forControlEvents:UIControlEventTouchUpInside];
                            [cell.background setFrame:CGRectMake(239, 75 - cell.grade / 2, 50, cell.grade / 2)];
                            
                            NSString *attdCheckedAt = [[data objectAtIndex:i] objectForKey:@"attdCheckedAt"];
                            cell.attdCheckedDate = [BTDateFormatter dateFromUTC:attdCheckedAt];
                            cell.gap = [BTDateFormatter intervalFromUTC:attdCheckedAt];
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
                }
                return cell;
            }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            if(indexPath.row == [supervisingCourses count])
                return 71.0f;
            else
                return 102.0f;
        case 1:
        default:
            if(indexPath.row == [attendingCourses count])
                return 71.0f;
            else
                return 102.0f;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(data.count != 0){
        CourseCell *cell = (CourseCell *)[self.tableview cellForRowAtIndexPath:indexPath];
        CourseDetailViewController *courseDetailViewController = [[CourseDetailViewController alloc] initWithNibName:@"CourseDetailViewController" bundle:nil];
        courseDetailViewController.currentcell = cell;
        
        if(indexPath.section == 0) {
            courseDetailViewController.auth = YES;
        } else {
            courseDetailViewController.auth = NO;
        }
        
        [self.navigationController pushViewController:courseDetailViewController animated:YES];
    }
}

-(void)startAnimation:(CourseCell *)cell {
    
    float height = (180.0f + cell.gap) / 180.0f * 50.0f;
    cell.background.frame = CGRectMake(239, 75 - height, 50, height);
    [cell.check_button removeTarget:self action:@selector(attdStart:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:180.0f + cell.gap
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [cell.background setFrame:CGRectMake(239, 75, 50, 0)];
                     }
                     completion:^(BOOL finished){
                         if (cell.isManager) {
                             [cell.check_button addTarget:self action:@selector(attdStart:) forControlEvents:UIControlEventTouchUpInside];
                         }
                         [cell.background setFrame:CGRectMake(239, 75 - cell.grade / 2, 50, cell.grade / 2)];
                     }];
    
    cell.blinkTime = 180 + cell.gap;
    if (cell.blink != nil)
        [cell.blink invalidate];
    NSTimer *blink = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(blink:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:cell,@"cell", nil] repeats:YES];
    cell.blink = blink;
}

-(void)blink:(NSTimer *)timer {
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

-(void)move_to_school:(id)sender{
    UIButton *comingbutton = sender;
    ButtonCell *comingcell = (ButtonCell *)comingbutton.superview.superview.superview;
    
    SchoolChooseView *schoolChooseView = [[SchoolChooseView alloc] init];
    if([self.tableview indexPathForCell:comingcell].section == 0){
        //cell from section 0
        schoolChooseView.auth = YES;
    }
    else{
        //cell from section 1
        schoolChooseView.auth = NO;
    }
    [self.navigationController pushViewController:schoolChooseView animated:YES];
}

-(void)attdStart:(id)sender{
    UIButton *send = (UIButton *)sender;
    CourseCell *cell = (CourseCell *)send.superview.superview.superview;
    attdStartingCid = [NSString stringWithFormat:@"%ld", (long)cell.CourseID];
    
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1 && [myCmanager state] == CBCentralManagerStatePoweredOn)
        [self startAttdCheck];
    
    if (buttonIndex == 0 && [myCmanager state] == CBCentralManagerStatePoweredOff)
        myPmanager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

-(void)startAttdCheck {
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"course_id":attdStartingCid};
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager POST:[BTURL stringByAppendingString:@"/post/attendance/start"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self startAttdScan];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}

-(void)checkAttdScan {
    //Attendance Start Check
    [attdingPostIDs removeAllObjects];
    for (int i = 0; i < data.count; i++) {
        NSString *attdCheckedAt = [[data objectAtIndex:i] objectForKey:@"attdCheckedAt"];
        int gap = [BTDateFormatter intervalFromUTC:attdCheckedAt];
        if (180.0f + gap > 0.0f) {
            NSArray *posts = [[data objectAtIndex:i] objectForKey:@"posts"];
            NSNumber *maxID = [posts valueForKeyPath:@"@max.intValue"];
            [attdingPostIDs addObject:maxID];
        }
    }
    
    //Attendance Start
    if ([attdingPostIDs count] > 0)
        [self startAttdScan];
}

-(void)startAttdScan {
    UIAlertView *alert;
    switch ([myCmanager state]) {
        case CBCentralManagerStatePoweredOn:{ //power-on
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
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{

    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSString *uuid = [BTUserDefault representativeString:[[advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey] objectAtIndex:0]];
    
    NSLog(@"Found %@", uuid);
    
    for (int i = 0; i < [attdingPostIDs count]; i++) {
        NSLog(@"Found %@ and postid %d", uuid, [[attdingPostIDs objectAtIndex:i] intValue]);
        NSDictionary *params = @{@"username":username,
                                 @"password":password,
                                 @"post_id":[[attdingPostIDs objectAtIndex:i] stringValue],
                                 @"uuid":uuid};
        
        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
        [AFmanager PUT:[BTURL stringByAppendingString:@"/post/attendance/found/device"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            
        }];
    }
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
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
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
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
            [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[myservice.UUID]}];
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
