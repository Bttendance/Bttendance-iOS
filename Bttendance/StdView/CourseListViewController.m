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
        
        myservice = [BTUserDefault getUserService];
        myCmanager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        myPmanager = [[CBPeripheralManager alloc] initWithDelegate:nil queue:nil];
        [myPmanager addService:myservice];
    }
    
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [BTColor BT_grey:1];
    [self tableview].backgroundColor = [BTColor BT_grey:1];
    
    rowcount1 = 1;
    rowcount2 = 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSString *uuid = [userinfo objectForKey:UUIDKey];
    
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"device_uuid":uuid};
    NSDictionary *params_ = @{@"username":username,
                              @"password":password};
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [AFmanager GET:[BTURL stringByAppendingString:@"/user/auto/signin"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        [BTUserDefault setUserInfo:responseObject];

        userinfo = [BTUserDefault getUserInfo];
        supervisingCourses = [userinfo objectForKey:SupervisingCoursesKey];
        attendingCourses = [userinfo objectForKey:AttendingCoursesKey];
        
        [AFmanager GET:[BTURL stringByAppendingString:@"/user/courses"] parameters:params_ success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            rowcount1 = [supervisingCourses count] + 1;
            rowcount2 = [attendingCourses count] + 1;
            data = responseObject;
            [self.tableview reloadData];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            NSLog(@"Get User Courses Fail : %@", error);
        }];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                            cell.backgroundColor = [BTColor BT_grey:1];
                            cell.cellbackground.backgroundColor = [BTColor BT_white:1];
                            cell.cellbackground.layer.cornerRadius = 2;
                            [cell.check_button addTarget:self action:@selector(attdStart:) forControlEvents:UIControlEventTouchUpInside];
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
                            cell.backgroundColor = [BTColor BT_grey:1];
                            cell.cellbackground.backgroundColor = [BTColor BT_white:1];
                            cell.cellbackground.layer.cornerRadius = 2;
                            [cell.check_button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
                            break;
                        }
                    }
                }
                return cell;
            }
    }
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(data.count != 0){
        CourseCell *cell = (CourseCell *)[self.tableview cellForRowAtIndexPath:indexPath];
        CourseDetailViewController *courseDetailViewController = [[CourseDetailViewController alloc] initWithNibName:@"CourseDetailViewController" bundle:nil];
        courseDetailViewController.currentcell = cell;
        
        if(indexPath.section == 0){
            //section 0
            courseDetailViewController.auth = YES;
        }
        else{
            //section 1
            courseDetailViewController.auth = NO;
        }
        
        [self.navigationController pushViewController:courseDetailViewController animated:YES];
    }
}

-(void)attdStart:(id)sender{

    UIButton *send = (UIButton *)sender;
    CourseCell *cell = (CourseCell *)send.superview.superview.superview;
    currentcell = cell;
    cid = [NSString stringWithFormat:@"%ld", (long)cell.CourseID];
    
    //alert showing
    NSString *string = @"Do you wish to start attendance check?";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attendance check" message:string delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==1){
        //start attendance
        NSString *username = [userinfo objectForKey:UsernameKey];
        NSString *password = [userinfo objectForKey:PasswordKey];
        
        NSDictionary *params = @{@"username":username,
                                 @"password":password,
                                 @"course_id":cid};
        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
        [AFmanager POST:@"http://www.bttendance.com/api/post/attendance/start" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
            //attendance start
            NSArray *posts = [responseObject objectForKey:@"posts"];
            
            //find pid
            pid = [NSString stringWithFormat:@"%d", [[[responseObject objectForKey:@"posts"] objectAtIndex:(posts.count-1)] intValue]];
            
            //time convert
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            
            NSDateFormatter *dm = [[NSDateFormatter alloc] init];
            [dm setTimeZone:[NSTimeZone timeZoneWithName:@"KST"]];
            
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [dateformatter setTimeZone:gmt];
            
            [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            [dm setDateFormat:@"yy/MM/dd HH:mm"];
            NSDate *updatedAt = [dateformatter dateFromString:[responseObject objectForKey:@"updatedAt"]];
            
            NSTimeInterval secs = [updatedAt timeIntervalSinceNow];
            
            currentcell.gap = secs;
            
            //start bt scan
            //advertise
            [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[myservice.UUID]}];
            //                                           , CBAdvertisementDataLocalNameKey:[[UIDevice currentDevice] name]}];
            NSLog(@"my servie uuid is %@", myservice.UUID);
            NSLog(@"my device name is %@", [[UIDevice currentDevice] name]);
            
            //scan
            [myCmanager scanForPeripheralsWithServices:nil options:nil];
            
            //image change start
//            [self showing_timer_course:currentcell];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            
        }];
    } else {
        //nothing to do
    }
}

#pragma mark - CBCentralManagerDelegate
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if(pid == nil){
        //wtf?? pid is null
    }
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSString *uuid = [BTUserDefault representativeString:[[advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey] objectAtIndex:0]];
    
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"post_id":pid,
                             @"uuid":uuid};
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
    [AFmanager PUT:@"http://www.bttendance.com/api/post/attendance/found/device" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        //alert showing
        NSString *string = @"Attendance Check Fail, please try again";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *state = nil;
    switch ([myCmanager state]) {
        case CBCentralManagerStateUnsupported:
            state = @"The platform hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:{
            state = @"Bluetooth is currently powered off.";
            //alert showing
            NSString *string = @"Please enable your Bluetooth for Attendance Check";
            NSString *title = @"Your Bluetooth is currently off";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        }
        case CBCentralManagerStatePoweredOn:
            state = @"power-on";
            break;
        case CBCentralManagerStateUnknown:
            state = @"Unknown state";
            break;
        default:
            state = @"default";
            break;
    }
}


@end
