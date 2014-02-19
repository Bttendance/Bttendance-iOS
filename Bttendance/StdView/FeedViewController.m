//
//  StdFeedView.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        rowcount = 0;
        userinfo = [BTUserDefault getUserInfo];
        my_id = [userinfo objectForKey:UseridKey];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage1:) name:@"NEWMESSAGE" object:nil];
        
        time = 180; //set time
        
        myservice = [BTUserDefault getUserService];
        myCmanager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        myPmanager = [[CBPeripheralManager alloc] initWithDelegate:nil queue:nil];
        
        [myPmanager addService:myservice];
        
        locationcheck = true;
        first_launch = true;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //set background color
    self.view.backgroundColor = [BTColor BT_grey:1];
    
    //set table background color
    [self tableview].backgroundColor = [BTColor BT_grey:1];
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSDictionary *params = @{@"username":username,
                             @"password":password};
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager GET:[BTURL stringByAppendingString:@"/user/feed"] parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
        
        data = responsObject;
        NSLog(@"data , %@", data);
        
        rowcount = data.count;
        [_tableview reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"get user's feeds fail : %@", error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //make post cell for student
    static NSString *CellIdentifierP = @"PostCell";
    
    rowcount = data.count;
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierP];
    
    if(cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.Title.text = [[data objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.Message.text = [[data objectAtIndex:indexPath.row] objectForKey:@"message"];
    
    cell.PostID = [[[data objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    
    //time convert
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    
    NSDateFormatter *dm = [[NSDateFormatter alloc] init];
    [dm setTimeZone:[NSTimeZone timeZoneWithName:@"KST"]];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateformatter setTimeZone:gmt];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dm setDateFormat:@"yy/MM/dd HH:mm"];
    NSDate *updatedAt = [dateformatter dateFromString:[[data objectAtIndex:indexPath.row] objectForKey:@"updatedAt"]];
    
    cell.Date.text = [dm stringFromDate:updatedAt];
    updatedAt = [dm dateFromString:cell.Date.text];
    
    NSTimeInterval secs = [updatedAt timeIntervalSinceNow];
    
    cell.gap = secs;
    
    cell.backgroundColor = [BTColor BT_grey:1];
    cell.cellbackground.backgroundColor = [BTColor BT_white:1];
    cell.cellbackground.layer.cornerRadius = 2;
    
    cell.timer = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if([[[data objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"notice"]){
        //notice
        [cell.check_icon setImage:[UIImage imageNamed:@"notice@2x.png"]];
        cell.isNotice = true;
        [cell.check_button setBackgroundImage:nil forState:UIControlStateNormal];
    } else {
        cell.isNotice = false;
    
        if(time + cell.gap <= 0){//time over;
            //check attendance completed
            NSArray *temp = [[data objectAtIndex:indexPath.row] objectForKey:@"checks"];
            Boolean check = false;
            for(int i = 0; i < temp.count ; i++){
                NSString *check_id = [NSString stringWithFormat:@"%@",[[[data objectAtIndex:indexPath.row] objectForKey:@"checks"]objectAtIndex:i]];
                if([my_id isEqualToString:check_id]){
                    check = true;
                }
            }
            if(!check){ // NOT ATTENDANCE!!!!
                //change image
                [cell.check_icon setImage:[UIImage imageNamed:@"attendfail@2x.png"]];
                [cell.check_button setBackgroundImage:Nil forState:UIControlStateNormal];
            }
        }
        else{//ongoing
            NSArray *temp = [[data objectAtIndex:indexPath.row] objectForKey:@"checks"];
            Boolean check = false;
            for(int i = 0; i < temp.count ; i++){
                NSString *check_id = [NSString stringWithFormat:@"%@",[[[data objectAtIndex:indexPath.row] objectForKey:@"checks"] objectAtIndex:i]];
                if([my_id isEqualToString:check_id]){
                    check = true;
                }
            }
            if(check){
                [cell.background setImage:nil];
            }
            else{
                if(first_launch){
                    //alert showing
                    NSString *string = @"Attendance Check has been started";
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    first_launch = false;

                    //start bt scan
                    //advertise
                    [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[myservice.UUID]}];
//                                                   , CBAdvertisementDataLocalNameKey:[[UIDevice currentDevice] name]}];
                    
                    //scan
                    [myCmanager scanForPeripheralsWithServices:nil options:nil];
                    
                    if([myPmanager state] == CBPeripheralManagerStatePoweredOff ||[myCmanager state] == CBCentralManagerStatePoweredOff){
                        //alert showing
                        NSString *string = @"Please enable your Bluetooth for Attendance Check";
                        NSString *title = @"Your Bluetooth is currently off";
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                }
                else{
                    //start bt scan
                    //advertise
                    [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[myservice.UUID]}];
//                                                   , CBAdvertisementDataLocalNameKey:[[UIDevice currentDevice] name]}];
                    
                    //scan
                    [myCmanager scanForPeripheralsWithServices:nil options:nil];
                }
                [self showing_timer_post:cell];
            }
        }
    }
    return cell;
    
}
-(void)receiveMessage1:(id)sender{
    NSLog(@"receive message");
    NSLog(@"sender info :%@" , sender);
    
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSDictionary *params = @{@"username":username,
                             @"password":password};
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager GET:[BTURL stringByAppendingString:@"/user/feed"] parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
        data = responsObject;
        
        rowcount = data.count;
        [_tableview reloadData];
        
        //start bt scan
        //advertise
        [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[myservice.UUID]}];
//                                       , CBAdvertisementDataServiceDataKey:[[UIDevice currentDevice] name] }];
        
        //scan
        [myCmanager scanForPeripheralsWithServices:nil options:nil];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"get user's feeds fail : %@", error);
    }];
    
}

-(void)showing_timer_post:(PostCell *)cell{
    float a = -cell.gap;
    float ratio = a/(float)time;
    
    if(time > a){
        [cell.background setImage:[UIImage imageNamed:@"0072b0.png"]];
        
        CGRect frame1 = cell.background.frame;
        frame1.size.height = cell.background.frame.size.height*(1.0f - ratio);
        frame1.origin.y = cell.background.frame.origin.y + cell.background.frame.size.height*ratio;
        cell.background.frame = frame1;
        
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:(time -a)];
        
        CGRect frame = cell.background.frame;
        frame.size.height = 0.0f;
        frame.origin.y = 77.0f;
        cell.background.frame = frame;
        [UIImageView commitAnimations];
        
        cell.timer = cell.timer - cell.gap;
        
        [cell.check_button addTarget:self action:@selector(send_attendance_check1:) forControlEvents:UIControlEventTouchUpInside];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(change_check_post1:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:cell,@"cell", nil] repeats:YES];
        
    }
}
-(void)change_check_post1:(NSTimer *)timer{
    PostCell *cell = [[timer userInfo] objectForKey:@"cell"];
    
    NSInteger i = cell.timer;
    
    if(i >= 2*time){
        [timer invalidate];
        timer = nil;
        i = 0;
        [myCmanager stopScan];
        [myPmanager stopAdvertising];
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

-(void)send_attendance_check1:(id)sender{
    UIButton *send = (UIButton *)sender;
    PostCell *cell = (PostCell *)send.superview.superview.superview;
    
    currentpostcell = cell;
    
    pid = [NSString stringWithFormat:@"%ld", (long)cell.PostID];
    
    //start bt scan
    //advertise
    [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[myservice.UUID]}];
//                                   , CBAdvertisementDataLocalNameKey:[[UIDevice currentDevice] name]}];
    NSLog(@"my servie uuid is %@", myservice.UUID);
    NSLog(@"my device name is %@", [[UIDevice currentDevice] name]);
    
    //scan
    [myCmanager scanForPeripheralsWithServices:nil options:nil];
    
//    //gps location start
//        locationmanager.delegate = self;
//        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
//        [locationmanager startUpdatingLocation];
    
    //disable button
    [cell.check_button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
}

#pragma - CBCentralManagerDelegate

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    if(pid == nil){
        pid = [NSString stringWithFormat:@"%ld", (long)((PostCell *)[[self tableview] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).PostID];
    }
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSString *uuid = [BTUserDefault representativeString:
                      [[advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey] objectAtIndex:0]];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"post_id":pid,
                             @"uuid":uuid};
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
    [AFmanager PUT:[BTURL stringByAppendingString:@"/post/attendance/found/device"] parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
        //attendance start
        NSLog(@"Send found device , %@",uuid);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        //alert showing
        NSString *string = @"Attendance Check Fail, please try again";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        //button restore
        [currentpostcell.check_button addTarget:self action:@selector(send_attendance_check1:) forControlEvents:UIControlEventTouchUpInside];
        
        NSLog(@"what!! the fuck :%@",operation.description);
        NSLog(@"send found device fail with %@", error);
        
        
        
    }];
    
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSLog(@"centralManagerDidUpdateState called");
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
    }
    
    NSLog(@"Central manager state : %@", state);
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    NSLog(@"peripheralmanagermanager didupdatestate called");
    NSString *state = nil;
    switch ([myPmanager state]) {
        case CBPeripheralManagerStateUnsupported:
            state = @"The platform hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBPeripheralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBPeripheralManagerStatePoweredOff:{
            state = @"Bluetooth is currently powered off.";
            //alert showing
            NSString *string = @"Please enable your Bluetooth for Attendance Check";
            NSString *title = @"Your Bluetooth is currently off";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        }
        case CBPeripheralManagerStatePoweredOn:
            state = @"power-on";
            break;
        case CBPeripheralManagerStateUnknown:
            state = @"Unknown state";
            break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

}


@end
