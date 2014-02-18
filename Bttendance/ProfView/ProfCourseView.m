//
//  ProfCourseView.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "ProfCourseView.h"

@interface ProfCourseView ()

@end

@implementation ProfCourseView
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if(self){
        rowcount = 0;
        data = [[NSMutableArray alloc] init];
        
        time = 180; //set time
        
        userinfo = [BTUserDefault getUserInfo];
        
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
    
    //set background color
    self.view.backgroundColor = [BTColor BT_grey:1];
    
    //set tableview background color
    [self tableview].backgroundColor = [BTColor BT_grey:1];
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    
    NSDictionary *params = @{@"username":username,
                             @"password":password};
    [AFmanager GET:@"http://www.bttendance.com/api/user/courses" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        data = responseObject;
        rowcount = data.count+1;
        [self.tableview reloadData];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Get User Courses Fail : %@", error);
    }];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    
    NSDictionary *params = @{@"username":username,
                             @"password":password};

    [AFmanager GET:@"http://www.bttendance.com/api/user/courses" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        data = responseObject;
        rowcount = data.count+1;
        [_tableview reloadData];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Get User Courses Fail : %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return rowcount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == rowcount-1){
        //add course button
        static NSString *CellIdentifier1 = @"ButtonCell";
        
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if(cell == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ButtonCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [BTColor BT_grey:1];
        
        [cell.button addTarget:self action:@selector(move_to_addpcv:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }
    else{
        static NSString *CellIdentifier = @"CourseCell";
        
        CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        cell.CourseName.text = [[data objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.Professor.text = [[data objectAtIndex:indexPath.row] objectForKey:@"professor_name"];
        cell.School.text = [[data objectAtIndex:indexPath.row] objectForKey:@"school_name"];
        cell.CourseID = [[[data objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        cell.backgroundColor = [BTColor BT_grey:1];
        cell.cellbackground.backgroundColor = [BTColor BT_white:1];
        cell.cellbackground.layer.cornerRadius = 2;
        
        [cell.check_button addTarget:self action:@selector(send_push1:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.timer = 0;
        
        //time convert
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        
        NSDateFormatter *dm = [[NSDateFormatter alloc] init];
        [dm setTimeZone:[NSTimeZone timeZoneWithName:@"KST"]];
        
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateformatter setTimeZone:gmt];
        
        [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        [dm setDateFormat:@"yy/MM/dd HH:mm"];
        NSDate *updatedAt = [dateformatter dateFromString:[[data objectAtIndex:indexPath.row] objectForKey:@"updatedAt"]];
        
        NSTimeInterval secs = [updatedAt timeIntervalSinceNow];
        
        cell.gap = secs;
        
        NSDictionary *posts = [[data objectAtIndex:indexPath.row] objectForKey:@"posts"];
        
        if(posts.count != 0){
            cell.lastpid = [[[[data objectAtIndex:indexPath.row] objectForKey:@"posts"] objectAtIndex:posts.count -1] integerValue];
        }
        else{
            cell.lastpid = 0;
        }
        
        if(time + cell.gap >0){
            //ongoing
            if(posts.count != 0){
                [cell.background setImage:[UIImage imageNamed:@"0072b0.png"]];
                
                [self showing_timer_course:cell];
                [cell.check_button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        
        return cell;
    }
    
}

-(void)showing_timer_course:(CourseCell *)cell{
    
    float a = -cell.gap;
    float ratio = a/(float)time;
    
    if(time > a){
        //ongoing
        
        [cell.background setImage:[UIImage imageNamed:@"0072b0.png"]];
        
        CGRect frame1 = cell.background.frame;
        frame1.size.height = 52.0*(1.0f - ratio);
        frame1.origin.y = 25.0 + 52.0*ratio;
        cell.background.frame = frame1;
        
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:(time -a)];
        
        CGRect frame = cell.background.frame;
        frame.size.height = 0.0f;
        frame.origin.y = 77.0f;
        cell.background.frame = frame;
        [UIImageView commitAnimations];
        
        cell.timer = cell.timer - cell.gap;
        
        [cell.nstimer invalidate];
        
        cell.nstimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(change_check_course:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:cell,@"cell", nil] repeats:YES];

    }
    
}

-(void)change_check_course:(NSTimer *)timer{
    
    CourseCell *cell = [[timer userInfo] objectForKey:@"cell"];
    
    NSInteger i = cell.timer;
    
    if(i >= 2*time){
        [timer invalidate];
        timer = nil;
        i = 0;
        [cell.check_button addTarget:self action:@selector(send_push1:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    int j = i%2;
    
    switch (j) {
        case 0:{
            cell.check_icon.alpha = 0;
            [UIImageView beginAnimations:nil context:NULL];
            [UIImageView setAnimationDuration:0.5];
            cell.check_icon.alpha = 1;
            [UIImageView commitAnimations];
            i++;
            cell.timer = i;
            break;
        }
        case 1:{
            cell.check_icon.alpha = 1;
            [UIImageView beginAnimations:nil context:NULL];
            [UIImageView setAnimationDuration:0.5];
            cell.check_icon.alpha = 0;
            [UIImageView commitAnimations];
            i++;
            cell.timer = i;
            break;
        }
        default:
            break;
    }
    
}

-(void)send_push1:(id)sender{
    UIButton *send = (UIButton *)sender;
    CourseCell *cell = (CourseCell *)send.superview.superview.superview;
    
    currentcell = cell;
    
    cid = [NSString stringWithFormat:@"%ld", (long)cell.CourseID];
    
    //disable button
    [cell.check_button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    
    //alert showing
    NSString *string = @"Do you wish to start attendance check?";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attendance check" message:string delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alert show];
    cell.gap = 0;
    
}

-(void)move_to_addpcv:(id)sender{
//    CourseView *courseView = [[CourseView alloc] init];
//    
//    [self.navigationController pushViewController:courseView animated:YES];
    CourseCreateController *createCourseController = [[CourseCreateController alloc] init];
    [self.navigationController pushViewController:createCourseController animated:YES];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //touch course cell
    //move to course detail view
    //send course cell
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==0){
        //cancel
        [currentcell.check_button addTarget:self action:@selector(send_push1:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(buttonIndex ==1){
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
            [self showing_timer_course:currentcell];
            
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            
        }];
    }
    else{
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
