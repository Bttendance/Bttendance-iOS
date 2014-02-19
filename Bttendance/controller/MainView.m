//
//  MainView.m
//  Bttendance
//
//  Created by HAJE on 2013. 12. 5..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "MainView.h"

@interface MainView ()

@end

@implementation MainView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rowcount = 0;
        userinfo = [BTUserDefault getUserInfo];
        my_id = [userinfo objectForKey:UseridKey];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"NEWMESSAGE" object:nil];

        time = 180;//set time
        first_launch = true;
//        CourseView *courseView = [[CourseView alloc] init];
//        
//        tbc = [[UITabBarController alloc] init];
//        [tbc setViewControllers:[NSArray arrayWithObjects:self, courseView,  nil] animated:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //set background color
    self.view.backgroundColor = [BTColor BT_grey:1];
    
    
    //set table background color
    [self tableview].backgroundColor = [BTColor BT_grey:1];
    
    //set tabbar color
    _tab_bar.backgroundColor = [BTColor BT_black:1];
    
    self.navigationController.navigationBarHidden = NO;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version >= 7){
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barTintColor = [BTColor BT_navy:1];
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Bttendance", @"");
    [titlelabel sizeToFit];
    
    myservice = [BTUserDefault getUserService];
    myCmanager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    myPmanager = [[CBPeripheralManager alloc] initWithDelegate:nil queue:nil];
    
    [myPmanager addService:myservice];
    
    
    NSLog(@"%@", userinfo);
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
    viewscope = true;
    
    
    if([[userinfo objectForKey:@"btd_type"] isEqualToString:@"professor"]){

        [_tab_bar setSelectedItem:_Course];//setting for  temp
        [_Feed setEnabled:FALSE];
    }
    else{
        [_tab_bar setSelectedItem:_Feed];//setting for  temp
    }
    // Do any additional setup after loading the view from its nib.

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    NSLog(@"view!!!!! will appear");
    
    viewscope = true;
    
    if([[userinfo objectForKey:@"btd_type"] isEqualToString:@"professor"]){
        //교수일때
        
        [_tab_bar setSelectedItem:_Course];//setting for  temp
        
        NSString *username = [userinfo objectForKey:UsernameKey];
        NSString *password = [userinfo objectForKey:PasswordKey];
        NSDictionary *params = @{@"username":username,
                                 @"password":password};
        
        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
        //교수 과목 불러오기
        [AFmanager GET:@"http://www.bttendance.com/api/user/courses" parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){//성공적으로 불러와지면 row에 추가하면서 display
            
            data = responsObject;
            rowcount = data.count + 1;
            [_tableview reloadData];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"get professor's courses fail : %@",error);
        }];
    }
    else if([[userinfo objectForKey:@"btd_type"] isEqualToString:@"student"]){
        //학생일때
        
        [_tab_bar setSelectedItem:_Feed];//setting for  temp
        
        NSString *username = [userinfo objectForKey:UsernameKey];
        NSString *password = [userinfo objectForKey:PasswordKey];
        NSDictionary *params = @{@"username":username,
                                 @"password":password};
        
        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
        [AFmanager GET:@"http://www.bttendance.com/api/user/feed" parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){

            data = responsObject;
            NSLog(@"data , %@", data);

            rowcount = data.count;
            [_tableview reloadData];

        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"get user's feeds fail : %@", error);
        }];
        
        
    }
    else{
        //error control
    }
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
    
    
    if([[userinfo objectForKey:@"btd_type"] isEqualToString:@"professor"]){
        //교수일때
        //make course cell
        
        if(indexPath.row == rowcount -1){
            //add course button
            static NSString *CellIdentifier2 = @"ButtonCell";
            
            ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            
            if(cell == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ButtonCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];

            }
            
            cell.backgroundColor = [BTColor BT_grey:1];
            
            [cell.button addTarget:self action:@selector(move_to_create:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            
        }
        
        else{
            static NSString *CellIdentifier = @"CourseCell";
            
            CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil){
                
                // Load the top-level objects from the custom cell XIB.
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil];
                
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
                cell = [topLevelObjects objectAtIndex:0];
            }
            cell.CourseName.text = [[data objectAtIndex:indexPath.row] objectForKey:@"name"];
            cell.Professor.text = [[data objectAtIndex:indexPath.row] objectForKey:@"professor_name"];
            cell.School.text = [[data objectAtIndex:indexPath.row] objectForKey:@"school_name"];
            cell.CourseID = [[[data objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
            cell.backgroundColor = [BTColor BT_grey:1];
            cell.cellbackground.backgroundColor = [BTColor BT_white:1];
            cell.cellbackground.layer.cornerRadius = 2;
            
            [cell.check_button addTarget:self action:@selector(send_push:) forControlEvents:UIControlEventTouchUpInside];
            
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
            
            cell.gap = secs; //gap setting
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSDictionary *posts = [[data objectAtIndex:indexPath.row] objectForKey:@"posts"];
            
            if(posts.count!=0){
                cell.lastpid = [[[[data objectAtIndex:indexPath.row] objectForKey:@"posts"]
                                 objectAtIndex:posts.count -1] integerValue];
            }
            else{
                cell.lastpid = 0;
            }
            
            if(time + cell.gap>0){
                //onging
                if(posts.count!= 0 ){
                    [self showing_timer:cell];
                    [cell.check_button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
                }
            }
            else{
                CGRect frame = cell.background.frame;
                
                frame.origin.y = 25;
                
                cell.background.frame = frame;
            }
            
           
            return cell;
        }
    }
    else{
        //학생일때
        //make post cell
        static NSString *CellIdentifier1 = @"PostCell";
        
        rowcount = data.count;

        PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
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
        
        
        //change image
//        int time = 20; //set time
        if(time + cell.gap <=0){//time over!
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
        else{
            NSArray *temp = [[data objectAtIndex:indexPath.row] objectForKey:@"checks"];
            Boolean check = false;
            for(int i = 0; i < temp.count ; i++){
                NSString *check_id = [NSString stringWithFormat:@"%@",[[[data objectAtIndex:indexPath.row] objectForKey:@"checks"] objectAtIndex:i]];
                if([my_id isEqualToString:check_id]){
                    check = true;
                }
            }
            if(check){
//                cell.check_icon setImage:[UIImage imageNamed:@""]
//                [cell.check_button setBackgroundImage:nil forState:UIControlStateNormal];
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
                    [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[myservice.UUID], CBAdvertisementDataLocalNameKey:[[UIDevice currentDevice] name]}];
                    NSLog(@"my servie uuid is %@", myservice.UUID);
                    NSLog(@"my device name is %@", [[UIDevice currentDevice] name]);
                    
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
                    [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[myservice.UUID], CBAdvertisementDataLocalNameKey:[[UIDevice currentDevice] name]}];
                    NSLog(@"my servie uuid is %@", myservice.UUID);
                    NSLog(@"my device name is %@", [[UIDevice currentDevice] name]);
                    
                    //scan
                    [myCmanager scanForPeripheralsWithServices:nil options:nil];
                    
                }
                [self showing_timer_post:cell];
            }
            
        }
        
        return cell;
    }

    
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[userinfo objectForKey:@"btd_type"] isEqualToString:@"professor"]){
        
        CourseCell *selected_cell = (CourseCell *)[[self tableview] cellForRowAtIndexPath:indexPath];
        
        NSString *selected_coursename = selected_cell.CourseName.text;
        NSInteger selected_cid = selected_cell.CourseID;
        NSInteger selected_lastpid = selected_cell.lastpid;
        
        AttdStatViewController *attdStatView = [[AttdStatViewController alloc] initWithNibName:@"AttdStatViewController" bundle:nil];
        
        attdStatView.courseName = selected_coursename;
        attdStatView.courseId = selected_cid;
        attdStatView.postId = selected_lastpid;
        
        [self.navigationController pushViewController:attdStatView animated:YES];
        
    }
}

- (IBAction)ScanButton:(id)sender {
    //advertise
    [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[myservice.UUID], CBAdvertisementDataLocalNameKey:[[UIDevice currentDevice] name]}];
    NSLog(@"my servie uuid is %@", myservice.UUID);
    NSLog(@"my device name is %@", [[UIDevice currentDevice] name]);
    
    //scan
    [myCmanager scanForPeripheralsWithServices:nil options:nil];
}

- (IBAction)StopButton:(id)sender {
    NSLog(@"stop scan and advertise");
    [myPmanager stopAdvertising];
    [myCmanager stopScan];
}

- (IBAction)AddRow:(id)sender {
    [[self tableview] beginUpdates];
    rowcount++;
    NSArray *insertindex = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],nil];
    [[self tableview] insertRowsAtIndexPaths:insertindex withRowAnimation:UITableViewRowAnimationNone];
    [[self tableview] endUpdates];
}

-(void)receiveMessage:(id)sender{
    NSLog(@"wow get message");
    NSLog(@"sender info :%@ ",sender);
    if([[userinfo objectForKey:@"btd_type"] isEqualToString:@"student"]){
        //학생일때
        NSString *username = [userinfo objectForKey:UsernameKey];
        NSString *password = [userinfo objectForKey:PasswordKey];
        NSDictionary *params = @{@"username":username,
                                 @"password":password};
        
        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
        [AFmanager GET:@"http://www.bttendance.com/api/user/feed" parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
            //            NSData *feeds = responsObject;
            //            data = [feeds allValues];
            data = responsObject;
            NSLog(@"data , %@", data);
            
            rowcount = data.count;
            [_tableview reloadData];
            
            
            
            //start bt scan
            //advertise
            [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[myservice.UUID], CBAdvertisementDataLocalNameKey:[[UIDevice currentDevice] name]}];
            NSLog(@"my servie uuid is %@", myservice.UUID);
            NSLog(@"my device name is %@", [[UIDevice currentDevice] name]);
            
            //scan
            [myCmanager scanForPeripheralsWithServices:nil options:nil];
            
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"get user's feeds fail : %@", error);
        }];
        
    }
    else{
        NSString *username = [userinfo objectForKey:UsernameKey];
        NSString *password = [userinfo objectForKey:PasswordKey];
        NSDictionary *params = @{@"username":username,
                                 @"password":password};
        
        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
        //교수 과목 불러오기
        [AFmanager GET:@"http://www.bttendance.com/api/user/courses" parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){//성공적으로 불러와지면 row에 추가하면서 display
            
            data = responsObject;
            rowcount = data.count + 1;
            [_tableview reloadData];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"get professor's courses fail : %@",error);
        }];

        
    }
}


-(IBAction)send_push:(id)sender{
    UIButton *send = (UIButton *)sender;
    CourseCell *cell = (CourseCell *)send.superview.superview.superview;
    
    currentcoursecell = cell;
    
    
    cid = [NSString stringWithFormat:@"%ld", (long)cell.CourseID];
    
    
    
    //disable button
    [cell.check_button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];

    
    //alert showing
    NSString *string = @"Do you wish to start attendance check?";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attendance check" message:string delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alert show];
    cell.gap = 0;
    
    
}

-(IBAction)move_to_create:(id)sender{
    CourseCreateController *createCourseController = [[CourseCreateController alloc] initWithNibName:@"CreateCourseController" bundle:nil];
    
    [self.navigationController pushViewController:createCourseController animated:YES];
    
}

- (IBAction)CourseCheck:(id)sender {
    CourseAttendView *courseview = [[CourseAttendView alloc] initWithNibName:@"CourseView" bundle:nil];
    [self.navigationController pushViewController:courseview animated:YES];
    
}

-(void)showing_timer_post:(PostCell *)cell{

//    int time = 20; //set time
    float a = -cell.gap;
    float ratio = a/(float)time;
    

    if( time > a){
        
        [cell.background setImage:[UIImage imageNamed:@"0072b0.png"]];
        
        CGRect frame1 = cell.background.frame;
        frame1.size.height = cell.background.frame.size.height*(1.0f-ratio);
        frame1.origin.y = cell.background.frame.origin.y + cell.background.frame.size.height*ratio;
        cell.background.frame = frame1;
        
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:(time - a)];
        
        CGRect frame = cell.background.frame;
        frame.size.height = 0.0f;
        frame.origin.y = 77.0f;
        cell.background.frame = frame;
        [UIImageView commitAnimations];

        cell.timer = cell.timer - cell.gap;

        [cell.check_button addTarget:self action:@selector(send_attendance_check:) forControlEvents:UIControlEventTouchUpInside];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(change_check_post:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:cell,@"cell", nil] repeats:YES];
    }
    
}

-(IBAction)send_attendance_check:(id)sender{
    UIButton *send = (UIButton *)sender;
    PostCell *cell = (PostCell *)send.superview.superview.superview;
    
    currentpostcell = cell;
    
    pid = [NSString stringWithFormat:@"%ld", (long)cell.PostID];
    
    
    
    //start bt scan
    //advertise
    [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[myservice.UUID], CBAdvertisementDataLocalNameKey:[[UIDevice currentDevice] name]}];
    NSLog(@"my servie uuid is %@", myservice.UUID);
    NSLog(@"my device name is %@", [[UIDevice currentDevice] name]);
    
    //scan
    [myCmanager scanForPeripheralsWithServices:nil options:nil];
    
    
    
    //gps location start
//    locationmanager.delegate = self;
//    locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationmanager startUpdatingLocation];

    //disable button
    [cell.check_button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)showing_timer:(CourseCell *)cell{
    [cell.background setImage:[UIImage imageNamed:@"0072b0.png"]];
    
    float a = -cell.gap;
    
    float ratio = a/((float)time);
    
    
    if(time > a){
        CGRect frame1 = cell.background.frame;
        frame1.size.height = cell.background.frame.size.height*(1.0f-ratio);
        frame1.origin.y = cell.background.frame.origin.y + cell.background.frame.size.height*ratio;
        cell.background.frame = frame1;
        
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:time];
        CGRect frame = cell.background.frame;
        frame.size.height = 0.0f;
        frame.origin.y = cell.background.frame.origin.y + cell.background.frame.size.height;
        cell.background.frame = frame;
        [UIImageView commitAnimations];

    //    NSNumber *i_timer = [NSNumber numberWithInteger:0];
    //    NSDictionary *userinfo = [NSDictionary dictionaryWithObjectsAndKeys:cell,@"cell",nil];
        
        cell.timer = cell.timer - cell.gap;
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(change_check_simbol:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:cell,@"cell", nil] repeats:YES];

    }
}

-(void)change_check_post:(NSTimer *)timer{
    
//    int time = 20; //set time
    
    PostCell *cell = [[timer userInfo] objectForKey:@"cell"];
    
    NSInteger i = cell.timer;
    
    if(i >= 2*time){
        [timer invalidate];
        timer = nil;
        i = 0;
        [cell.check_button addTarget:self action:@selector(send_push:) forControlEvents:UIControlEventTouchUpInside];
//        CGRect frame = cell.background.frame;
//        frame.size.height = 52.0f;
//        frame.origin.y = frame.origin.y - 52.0f;
//        cell.background.frame = frame;
//        cell.background.image = nil;
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

-(void)change_check_simbol:(NSTimer *)timer{
    
//    int time = 20; //set time
    
    CourseCell *cell = [[timer userInfo] objectForKey:@"cell"];
    
    NSInteger i = cell.timer;
    
    if(i >= 2*time){
        [timer invalidate];
        timer = nil;
        i = 0;
        [cell.check_button addTarget:self action:@selector(send_push:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = cell.background.frame;
        frame.size.height = 52.0f;
        frame.origin.y = 25;
        cell.background.frame = frame;
        cell.background.image = nil;
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

#pragma - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered identifier %@", peripheral.identifier);
    NSLog(@"Discovered adv %@", advertisementData);
    NSLog(@"discovered adv service data %@", [advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey]);
    NSLog(@"Name : %@", [peripheral name]);
    
    if(pid == nil){
        pid = [NSString stringWithFormat:@"%ld",
                (long)((PostCell *)[[self tableview] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).PostID];
    }
    
//    if([[userinfo objectForKey:@"btd_type"] isEqualToString:@"student"]){
        NSString *username = [userinfo objectForKey:UsernameKey];
        NSString *password = [userinfo objectForKey:PasswordKey];
        NSString *uuid = [BTUserDefault representativeString:
        [[advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey] objectAtIndex:0]];
        NSDictionary *params = @{@"username":username,
                                 @"password":password,
                                 @"post_id":pid,
                                 @"uuid":uuid};
        
        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
        
        [AFmanager PUT:@"http://www.bttendance.com/api/post/attendance/found/device" parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
            //attendance start
            NSLog(@"Send found device , %@",uuid);
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            
            //alert showing
            NSString *string = @"Attendance Check Fail, please try again";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            //button restore
            [currentpostcell.check_button addTarget:self action:@selector(send_attendance_check:) forControlEvents:UIControlEventTouchUpInside];
            
            NSLog(@"what!! the fuck :%@",operation.description);
            NSLog(@"send found device fail with %@", error);
            
            
            
        }];

//    }
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
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
            break;
    }
    
    NSLog(@"Central manager state : %@", state);
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"peripheral try to connect to this device");
    
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
    if([[userinfo objectForKey:@"btd_type"] isEqualToString:@"professor"] && buttonIndex==1){
        NSString *username = [userinfo objectForKey:UsernameKey];
        NSString *password = [userinfo objectForKey:PasswordKey];
        
        NSDictionary *params = @{@"username":username,
                                 @"password":password,
                                 @"course_id":cid};
        
        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
        
        [AFmanager POST:@"http://www.bttendance.com/api/post/attendance/start" parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
            //attendance start
            NSLog(@"Attendance check Start! , %@",responsObject);
            
            NSArray *posts = [responsObject objectForKey:@"posts"];
            
            //find current pid
            pid = [NSString stringWithFormat:@"%d",[[[responsObject objectForKey:@"posts"] objectAtIndex:(posts.count-1)] intValue]];

            //time convert
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            
            NSDateFormatter *dm = [[NSDateFormatter alloc] init];
            [dm setTimeZone:[NSTimeZone timeZoneWithName:@"KST"]];
            
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [dateformatter setTimeZone:gmt];
            
            [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            [dm setDateFormat:@"yy/MM/dd HH:mm"];
            NSDate *updatedAt = [dateformatter dateFromString:[responsObject objectForKey:@"updatedAt"]];
            
            NSTimeInterval secs = [updatedAt timeIntervalSinceNow];
            
            currentcoursecell.gap = secs;
            
//            [self showing_timer:currentcoursecell];
            
            //start bt scan
            //advertise
            [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[myservice.UUID], CBAdvertisementDataLocalNameKey:[[UIDevice currentDevice] name]}];
            NSLog(@"my servie uuid is %@", myservice.UUID);
            NSLog(@"my device name is %@", [[UIDevice currentDevice] name]);
            
            //scan
            [myCmanager scanForPeripheralsWithServices:nil options:nil];
            
            //gps location start
            //        locationmanager.delegate = self;
            //        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
            //        [locationmanager startUpdatingLocation];
            
            
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            //attendance start fail
            NSLog(@"%@",operation.responseString);
            
            //alert showing
            NSString *string = @"Attendance Check Fail, please try again";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            //button restore
            [currentcoursecell.check_button addTarget:self action:@selector(send_push:) forControlEvents:UIControlEventTouchUpInside];
            NSLog(@"Attendance Check Start fail with %@", error);
            
            
        }];
    }
    if([[userinfo objectForKey:@"btd_type"] isEqualToString:@"professor"] && buttonIndex==0){
        [currentcoursecell.check_button addTarget:self action:@selector(send_push:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if(item == _Course && viewscope
       &&[[userinfo objectForKey:@"btd_type"] isEqualToString:@"student"]){
        CourseAttendView *courseview = [[CourseAttendView alloc] initWithNibName:@"CourseView" bundle:nil];
        [self.navigationController pushViewController:courseview animated:NO];
        viewscope = false;
    }
}

@end
